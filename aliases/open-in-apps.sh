# Function / Aliases to help with opening files with specific apps!

function open:macdown(){
  fuzzy_app MacDown "$@"
}

function open:typora(){
  fuzzy_app Typora "$@"
}

function open:abricotine(){
  fuzzy_app Abricotine "$@"
}

function open:iawriter(){
  fuzzy_app "iA Writer" "$@"
}

function open:pycharm(){
  open -a "PyCharm CE" $@
}

function open:dropbox-notex(){
  (cd "${DIR_FOR_IA_WRITER}" ; fuzzy_app "iA Writer")
}

function open:icloud-notes(){
  (cd "${DIR_FOR_IA_WRITER_ICLOUD}" ; fuzzy_app "iA Writer")
}

# function open:personalbook(){
#   (cd "${DIR_FOR_PERSONALBOOK}" ; fuzzy_app "iA Writer")
# }

function open:personalbook(){
  (cd "$(find_personalbook_dir)" ; fuzzy_app "iA Writer")
}

alias pb="open:personalbook"

# Sublime Shortcut. Depends on the installation of sublime.
alias open:subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias open:chrome='open -a "Google Chrome"'
alias open:excel='open -a "Microsoft Excel"'
alias open:intellij='/usr/local/bin/idea'
alias open:atom="/Applications/Atom.app/Contents/Resources/app/atom.sh"
alias open:preview='qlmanage -p'
alias open:vscode='open -a "Visual Studio Code"'

alias open:atom-environment="open:atom ${DIRS_ENVIRONMENT}/"
alias open:atom-noteplan-personal="open:atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_PERSONAL_EMAIL}/Noteplan/Documents/"
alias open:atom-noteplan-work="open:atom ${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_WORK_EMAIL}/Noteplan/Documents/"

function js(){
  j $1; /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .;
}
