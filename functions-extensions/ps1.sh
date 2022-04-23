# ps1.sh

# https://superuser.com/questions/399594/color-scheme-not-applied-in-iterm2

# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

export PROMPT_COMMAND=__prompt_command    # Function to generate PS1 after CMDs

function only_trigger_if_in_src_code_folder() {
    (pwd | egrep -q -E "^${HOME}/workplace/[^/]+/src/[^/]+")
}

function vs_get() {
    brazil ws show -f json 2>/dev/null \
        | jq -cr '.version_set|"\(.name):\(.event_id)"'
}

function ctx-lite() {
   jq -n $@ \
       --arg aws "${AWS_PROFILE}" \
       --arg conda "${CONDA_PROMPT_MODIFIER}" \
       '{aws: $aws, conda: $conda|sub("[ )(]"; ""; "g")}'
}

function ctx() {
    VERSION_SET=$(\
        (\
            only_trigger_if_in_src_code_folder && vs_get
        ) \
        || true \
    )
    # https://digitalfortress.tech/tips/setting-up-git-prompt-step-by-step/
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_HIDE_IF_PWD_IGNORED=true
    GIT_PS1_SHOWCOLORHINTS=true
    GIT=$(\
        only_trigger_if_in_src_code_folder && __git_ps1 \
    )
    ctx-lite | \
	jq -c \
   		--arg versionSet "${VERSION_SET}" \
   		--arg git "${GIT}" \
     		'. + {VersionSet: $versionSet, git: $git|sub("[ )(]"; ""; "g")}'
}

# https://stackoverflow.com/questions/16715103/bash-prompt-with-the-last-exit-code
__prompt_command() {
    local EXIT="$?"                # This needs to be first
    local _PS1=""

    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local BRed='\[\e[1;31m\]'
    local Gre='\[\e[0;36m\]'
    local BGre='\[\e[1;36m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'

    if [ $EXIT != 0 ]; then
        _PS1+="${BRed}⇡⇡⇡⇡⇡⇡⇡⇡⇡⇡⇡⇡ ⏱  \D{%Y-%m-%dT%H:%M:%S-05:00} 🛑  [${EXIT}]${RCol}"        # Add red if exit code non 0
    else
        _PS1+="${BGre}⇡⇡⇡⇡⇡⇡⇡⇡⇡⇡⇡⇡ ⏱  \D{%Y-%m-%dT%H:%M:%S-05:00} 🟢  ${RCol}"
    fi
    CONTEXT=$(ctx-lite -cC)
    _PS1+="\n--------------------------------------------------------------------"
    _PS1+="\n${CONTEXT}"
    _PS1+="\n⇣⇣⇣⇣⇣⇣⇣⇣⇣⇣⇣⇣ 💻 \u@${BBlu}\h ${Pur}\W${BYel}$ ${RCol}"
    export PS1="${_PS1}"
}

# ------------------------------------------------------------

export DISABLE_AUTO_TITLE="true"

setTerminalText () {
    # Works in bash & zsh
    # $1 is where we want to set the title
    #	=> { 0: both, 1: tab, 2: title}
    local mode=$1 ; shift
    echo -ne "\033]$mode;$@\007"
}
title_terminal () { setTerminalText 2 $@; }
title_both () { setTerminalText 0 $@; }
title () { setTerminalText 1 $@; }
title-from-dir () { title $(basename ${PWD}) ; }

function week_prompt(){
    jq -n \
	--arg now "$(date +%Y-%m-%dT%H:%M:%S%z)" \
	--arg utcnow "$(date -u +%Y-%m-%dT%H:%M:%S%z)" \
	--arg aws "$(echo ${AWS_PROFILE})" \
	'{} | (.now |= $now) | (.aws |= $aws)' \
    | ( \
        test -f ${HOME}/.cortex/config \
            &&  jq --arg cortex_profile "$(jq -r '.currentProfile' ${HOME}/.cortex/config)" '(.cortex |= $cortex_profile)' \
            ||  jq '.' \
      ) \
    | jq -c '.'
}

function bash_title {
   # setup terminal tab title ... only works in bash
   if [ "$1" ]
   then
       unset PROMPT_COMMAND
       echo -ne "\033]0;${*}\007"
   else
       export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
   fi
}

function tab-rename {
  printf "\e]1;$1\a"
}

function win-rename {
  printf "\e]2;$1\a"
}
