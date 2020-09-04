# App Based Aliases ... these generally depend on other apps being present ...
# -----------------------------------------------------------------------------

# Fuzzy Config ...
FZF_IGNORE_PATTERNS='*.pyc|*.class|*.iml|*.DS_Store'
FZF_IGNORE_PATTERNS=$(split_and_prefix "${FZF_IGNORE_PATTERNS}" "--ignore")
FZF_IGNORE_DIRS=".git|target|.idea|.atom|.bash_sessions|.cache|.config|Music|Pictures|google-drive-c12e"
FZF_IGNORE_DIRS=$(split_and_prefix "${FZF_IGNORE_DIRS}" "--ignore-dir")
export FZF_DEFAULT_COMMAND="ag --hidden ${FZF_IGNORE_PATTERNS} ${FZF_IGNORE_DIRS} -g '' "

# ------------------------------------------------------------------------------

function e() {
    # Seach executables!
    compgen -c |  egrep  '^[a-z]' | sort | fzf --preview "which {}" --color light --margin 5,20
}
alias s='fzf'
alias apm="/Applications/Atom.app/Contents/Resources/app/apm/bin/apm"
alias mvim=/Applications/MacVim.app/Contents/bin/mvim
alias atom="/Applications/Atom.app/Contents/Resources/app/atom.sh"


function fuzzy_app(){
  if [[ -z "$2" ]];
  then
    fzf | xargs -I __ bash -c 'echo "__" | pbcopy; open -a "${0}" "__"' "${1}" 
  else
    echo "${2}" | pbcopy
    open -a ${1} $2
  fi
}

function fvi(){
  FILE=$(fzf)
  test "${FILE}" != "" && vi "${FILE}"
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

# - [ ] Autogenerate this at the end of each of the sh methods!
if [[ "${DETECTED_SHELL}" = "BASH" ]]
then
    export -f fuzzy_app
    export -f fvi
    export -f fcat
    export -f fcopy
    export -f peek
    export -f peek-near-term
    export -f fj
    export -f dir
fi
