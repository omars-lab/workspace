# https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Installation
set_prompt () {
    # Need to SOURCE git-prompt.sh BEFORE sourcing this dude.

    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    PS1=""

    # First print the status of prev cmd and all the envs
    # If last was successful, print a green check, Otherwise, red X
    if [[ $Last_Command == 0 ]]; then
        PS1+="${Green}"
        _status="\$? $Checkmark"
    else
        PS1+="${Red}"
        _status="\$? $FancyX"
    fi
    # PS1+="-------------------- Exit Status: $_status --------------------"
    PS1+="$_status "
    PS1+="$Reset"

    #PSI1+="\ncmd=$White\!$Reset "

    # Set the git stuff
    PS1+="$(__git_ps1 "git=$White%s$Reset ")"

    # Determine the python virtual env that is currently enabled.
    if [[ ${VIRTUAL_ENV##*/} ]]; then
        current_venv="py=$White${VIRTUAL_ENV##*/}$Reset "
    else
        current_venv=" "
    fi
    PS1+=${current_venv}

    # Detemine the current nvm we are using
    _current_nvm=$(nvm current | grep -v none)
    if [[ $_current_nvm ]]; then
        current_nvm="nvm=$White${_current_nvm}$Reset "
    else
        current_nvm=" "
    fi
    PS1+=${current_nvm}

    # Determine the current shell environment we have enabled.
    if [[ ${ENV_ID} ]]; then
        current_shenv="bash=$White${ENV_ID}$Reset "
    else
        current_shenv=" "
    fi
    PS1+=${current_shenv}

    # Add the command num, date, time and current directory:
    PS1+="pwd=$Blue\\W$Reset "
    PS1+="$White\\\$\!$Reset "
}

# PROMPT_COMMAND='set_prompt'  # old: update_terminal_cwd

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# stty columns 1000
# export PS1=$(colored_ps1)
# export PS1="\t | \u | \W ›› "
