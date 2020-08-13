# Function / Aliases to help with opening files with specific apps!

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

function pycharm(){
  open -a "PyCharm CE" $@
}

function dropbox-notex(){
  (cd "${DIR_FOR_IA_WRITER}" ; fuzzy_app "iA Writer")
}

function icloud-notes(){
  (cd "${DIR_FOR_IA_WRITER_ICLOUD}" ; fuzzy_app "iA Writer")
}

# function open:personalbook(){
#   (cd "${DIR_FOR_PERSONALBOOK}" ; fuzzy_app "iA Writer")
# }

function iawriter:personalbook(){
  (cd "$(find_personalbook_dir)" ; fuzzy_app "iA Writer")
}

function link:iawriter:personalbook(){
  (cd "$(find_personalbook_dir)" ; fzf | html-encode | xargs -I {} echo "ia-writer://open?path=/Locations/personalbook/{}" )
}

function vi:personalbook(){
  (cd "$(find_personalbook_dir)" ; fvi)
}

function vi:noteplan(){
  (cd "${NOTEPLAN_ICLOUD_DIR}/Calendar" ; fvi)
}

function vi:noteplan-notes(){
  (cd "${NOTEPLAN_ICLOUD_DIR}/Notes" ; fvi)
}

alias pb="iawriter:personalbook"
alias n="iawriter:personalbook"

# Sublime Shortcut. Depends on the installation of sublime.
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias chrome='open -a "Google Chrome"'
alias excel='open -a "Microsoft Excel"'
alias intellij='/usr/local/bin/idea'
alias atom="/Applications/Atom.app/Contents/Resources/app/atom.sh"
alias preview='qlmanage -p'
alias vscode='open -a "Visual Studio Code"'

alias atom:environment="open:atom ${DIRS_ENVIRONMENT}/"
alias atom:noteplan-personal="open:atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_PERSONAL_EMAIL}/Noteplan/Documents/"
alias atom:noteplan-work="open:atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_WORK_EMAIL}/Noteplan/Documents/"

function js(){
  j $1; /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .;
}

