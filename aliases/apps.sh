# App Based Aliases ... these generally depend on other apps being present ...
# -----------------------------------------------------------------------------

function get_other_user(){
  USERS=$(dscl . list /Users | grep -v "^_" | grep --color=never eid | tr '\n' ' ')
  # This lists all "logged in" users ... this wont work if I first boot up the mac ...
  # USERS=$(users | sed -e "s/$(whoami)//g" -e 's/ *//g')
  echo ${USERS} | sed -e "s/$(whoami)//g" -e 's/ *//g'
}

#Every users writes into their own dir ...
export SHARED_CLIPBOARD_LOCATION=/Users/Shared/clipboard/$(get_other_user)/ingest
export SHARED_CLIPBOARD_IGNORE_DIR=/Users/Shared/clipboard/$(whoami)/ingested
mkdir -p ${SHARED_CLIPBOARD_IGNORE_DIR}

# Fuzzy Config ...
FZF_IGNORE_PATTERNS=$'(*.pyc)|(*.class)|(*.iml)|(*.DS_Store)'
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
alias atom-environment="atom ${DIRS_ENVIRONMENT}/"
alias atom-noteplan-personal="atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_PERSONAL_EMAIL}/Noteplan/Documents/"
alias atom-noteplan-work="atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_WORK_EMAIL}/Noteplan/Documents/"

alias mvim=/Applications/MacVim.app/Contents/bin/mvim

alias preview='qlmanage -p'

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

function pbcopy-from-shared-clipboard-archive(){
    FILE_TO_COPY=$( \
      (find ${SHARED_CLIPBOARD_IGNORE_DIR} -type f -exec ls -1t "{}" +;) \
        | peek \
    )
    test -f "${FILE_TO_COPY}" && (cat ${FILE_TO_COPY} | pbcopy)
}

function pbcopy-from-shared-clipboard(){
    # Make temp file ...
    SHARED_CLIPBOARD_IGNORE_FILE=$(mktemp)
    ls ${SHARED_CLIPBOARD_IGNORE_DIR} | sed -e 's/^/(/g' -e 's/$/)/g' | tr '\n' '|' | sed -e 's/|$//g' > ${SHARED_CLIPBOARD_IGNORE_FILE}

    FILE_TO_COPY=$( \
      (find ${SHARED_CLIPBOARD_LOCATION} -type f -exec ls -1t "{}" +;) \
        | ( test -s ${SHARED_CLIPBOARD_IGNORE_FILE} && egrep -v -f ${SHARED_CLIPBOARD_IGNORE_FILE} || cat) \
        | peek \
    )

    test -f "${FILE_TO_COPY}" && (cat "${FILE_TO_COPY}" | pbcopy)
    test -f "${FILE_TO_COPY}" &&  cp "${FILE_TO_COPY}" "${SHARED_CLIPBOARD_IGNORE_DIR}"

    # Clean up temp file ...
    rm ${SHARED_CLIPBOARD_IGNORE_FILE}
}

function pbrm-from-shared-clipboard(){
    # This is not a hard remove ... it just adds the file to an ignore dir ... i.e archives it ..
    SHARED_CLIPBOARD_IGNORE_FILE=$(mktemp)
    ls ${SHARED_CLIPBOARD_IGNORE_DIR} | sed -e 's/^/(/g' -e 's/$/)/g' | tr '\n' '|' | sed -e 's/|$//g' > ${SHARED_CLIPBOARD_IGNORE_FILE}

    FILE_TO_ARCHIVE=$( \
      (find ${SHARED_CLIPBOARD_LOCATION} -type f -exec ls -1t "{}" +;) \
        | ( test -s ${SHARED_CLIPBOARD_IGNORE_FILE} && egrep -v -f ${SHARED_CLIPBOARD_IGNORE_FILE} || cat) \
        | peek \
    )
    test -f "${FILE_TO_ARCHIVE}" && cp ${FILE_TO_ARCHIVE} ${SHARED_CLIPBOARD_IGNORE_DIR}/
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
