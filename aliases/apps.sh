
# Sublime Shortcut. Depends on the installation of sublime.
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
function js () {
  j $1; /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .;
} 
alias e="subl"

alias notes="j Notes; atom .; cd -"

alias chrome='open -a "Google Chrome"'
alias excel='open -a "Microsoft Excel"'

alias intellij='/usr/local/bin/idea'

# allow ctrl-r to work with terminal vi-Mode
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

alias mvim=/Applications/MacVim.app/Contents/bin/mvim

FZF_IGNORE_PATTERNS=$'(*.pyc)|(*.class)|(*.iml)'
FZF_IGNORE_DIRS=".git|target|.idea|.atom|.bash_sessions|.cache|.config"
FZF_IGNORE_DIRS=$( \
  echo "${FZF_IGNORE_DIRS}" \
    |  tr "|" "\n" \
    | xargs printf " --ignore-dir '%s' "\
)
export FZF_DEFAULT_COMMAND="ag --hidden --ignore '${FZF_IGNORE_PATTERNS}' ${FZF_IGNORE_DIRS} -g '' "

function fuzzy_app(){
  if [[ -z "$2" ]] then 
    fzf | xargs -I {} open -a ${1} {}
  else 
    open -a ${1} $2
  fi
}

function macdown() { fuzzy_app MacDown "$@" }
function typora() { fuzzy_app Typora "$@" }
function abricotine() { fuzzy_app Abricotine "$@" }
function iawriter() { fuzzy_app iA\ Writer "$@" }

function fj() {
  cd $(j --complete ${1} | egrep -o '/.*' | fzf)
}

function fcat() {
  fzf | xargs cat 
}

function fcopy() {
  fcat | pbcopy
}
