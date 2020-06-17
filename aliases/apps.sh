# App Based Aliases ... these generally depend on other apps being present ...
# -----------------------------------------------------------------------------

# Fuzzy Config ...
FZF_IGNORE_PATTERNS='*.pyc|*.class|*.iml|*.DS_Store'
FZF_IGNORE_PATTERNS=$(split_and_prefix "${FZF_IGNORE_PATTERNS}" "--ignore")
FZF_IGNORE_DIRS=".git|target|.idea|.atom|.bash_sessions|.cache|.config|Music|Pictures|google-drive-c12e"
FZF_IGNORE_DIRS=$(split_and_prefix "${FZF_IGNORE_DIRS}" "--ignore-dir")
export FZF_DEFAULT_COMMAND="ag --hidden ${FZF_IGNORE_PATTERNS} ${FZF_IGNORE_DIRS} -g '' "

# ------------------------------------------------------------------------------

alias e="subl"
alias s='fzf'
alias apm="/Applications/Atom.app/Contents/Resources/app/apm/bin/apm"
alias mvim=/Applications/MacVim.app/Contents/bin/mvim

alias atom="/Applications/Atom.app/Contents/Resources/app/atom.sh"

alias atom-environment="atom ${DIRS_ENVIRONMENT}/"
alias atom-noteplan-personal="atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_PERSONAL_EMAIL}/Noteplan/Documents/"
alias atom-noteplan-work="atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_WORK_EMAIL}/Noteplan/Documents/"

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
  fzf --preview "head -$LINES {}" --color light --margin 5,20
}

function peek-near-term(){
  fzf --preview "grep -b3 -a3 ${1} {}"
}

function fj() {
  cd $(j --complete ${1} | egrep -o '/.*' | fzf)
}

function dir(){
  cd $(j --complete ${1} | egrep -o '/.*' | fzf | pbcopy)
}

# cat aliases/apps.sh | grep 'function ' | sed -e 's/(.*//g' -e 's/function //g' | sed -e 's/^/export -f /g'

if [[ "${DETECTED_SHELL}" = "BASH" ]]
then
    export -f upper
    export -f lower
    export -f get_other_user
    export -f js
    export -f fuzzy_app
    export -f fcat
    export -f fcopy
    export -f peek
    export -f peek-near-term
    export -f pbcopy-from-shared-clipboard-archive
    export -f pbcopy-from-shared-clipboard
    export -f pbrm-from-shared-clipboard
    export -f macdown
    export -f typora
    export -f abricotine
    export -f iawriter
    export -f notes
    export -f notes-cloud
    export -f fj
    export -f dir
    export -f pycharm
fi
