# App Based Aliases ... these generally depend on other apps being present ...

# Fuzzy Config ...
FZF_IGNORE_PATTERNS=$'(*.pyc)|(*.class)|(*.iml)'
FZF_IGNORE_DIRS=".git|target|.idea|.atom|.bash_sessions|.cache|.config"
FZF_IGNORE_DIRS=$( \
  echo "${FZF_IGNORE_DIRS}" \
    |  tr "|" "\n" \
    | xargs printf " --ignore-dir '%s' "\
)
export FZF_DEFAULT_COMMAND="ag --hidden --ignore '${FZF_IGNORE_PATTERNS}' ${FZF_IGNORE_DIRS} -g '' "

# Sublime Shortcut. Depends on the installation of sublime.
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias e="subl"

alias chrome='open -a "Google Chrome"'
alias excel='open -a "Microsoft Excel"'
alias intellij='/usr/local/bin/idea'

alias apm="/Applications/Atom.app/Contents/Resources/app/apm/bin/apm"
alias atom="/Applications/Atom.app/Contents/Resources/app/atom.sh"
alias atom-noteplan-personal="atom ${DIRS_ENVIRONMENT}/backup/${ICLOUD_PERSONAL_EMAIL}/Noteplan/Documents"
alias atom-notepla-work="atom ${DIRS_ENVIRONMENT}/backup/${ICLOUD_WORK_EMAIL}/Noteplan/Documents"

alias mvim=/Applications/MacVim.app/Contents/bin/mvim

function js(){
  j $1; /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .;
}

function fuzzy_app(){
  if [[ -z "$2" ]];
  then
    fzf | xargs -I {} open -a ${1} {}
  else
    open -a ${1} $2
  fi
}

function fcat(){
  fzf | xargs cat
}

function fcopy(){
  fcat | pbcopy
}

function peek(){
  grep -rl "${1}" . | fzf --preview "grep -b3 -a3 ${1} {}"
}

function macdown(){
  fuzzy_app MacDown "$@"
}

function typora(){
  fuzzy_app Typora "$@"
}

function abricotine(){
  fuzzy_app Abricotine "$@"
}

function iawriter(){
  fuzzy_app "iA Writer" "$@"
}

function fj() {
  cd $(j --complete ${1} | egrep -o '/.*' | fzf)
}

function dir(){
  cd $(j --complete ${1} | egrep -o '/.*' | fzf | pbcopy)
}
