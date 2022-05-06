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
  (cd "$(find_personalbook_dir)" ; fuzzy_selector "iA Writer")
}

alias pb="iawriter:personalbook"
alias pbl="link:iawriter:personalbook | pbcopy"

alias preview='qlmanage -p'

alias chrome='open -a "Google Chrome"'

alias excel='open -a "Microsoft Excel"'

# - [ ] add some interceptor code to track how many times I actually use some of these shortcuts!
