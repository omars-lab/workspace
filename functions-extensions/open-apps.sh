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

alias preview='qlmanage -p'

alias chrome='open -a "Google Chrome"'

alias excel='open -a "Microsoft Excel"'

# - [ ] add some interceptor code to track how many times I actually use some of these shortcuts!


function open_and_echo() {
  xargs -I __ bash -c 'open "${0}"; echo "${0}"' "__"
}

function open-vscode-link() {
    find_files | fzf | gsed -E "s#^[.]/#${PWD}/#g" | vscode-link | tr -d '\n' | open_and_echo
}

function open-iawriter-link() ( 
    find_iawriter_files | fzf | sed-url-encode | gsed -E "s#^#ia-writer://open?path=/Locations/#g" | tr -d '\n'| open_and_echo
)

function open-document-link() {
    find_vscode_documents | fzf | vscode-link | tr -d '\n' | open_and_echo
}

function open-noteplan-reference() {
    noteplan-references | fzf | tr -d '\n' | open_and_echo 
}

function open-noteplan-references() {
    noteplan-references | open_and_echo
}

function open-noteplan-documents() {
    find_noteplan_documents | fzf | vscode-link | tr -d '\n' | open_and_echo
}

function open-glue-link() {
    glue-links | tr -d '\n' | open_and_echo
}

alias pick=open-vscode-link
alias choose=open-vscode-link
