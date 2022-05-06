# Every users writes into their own dir ...
export SHARED_CLIPBOARD_LOCATION=/Users/Shared/clipboard/$(get_other_user)/ingest
export SHARED_CLIPBOARD_IGNORE_DIR=/Users/Shared/clipboard/$(whoami)/ingested


function pbcopy-from-shared-clipboard-archive(){
	mkdir -p ${SHARED_CLIPBOARD_IGNORE_DIR}
    FILE_TO_COPY=$( \
      (find ${SHARED_CLIPBOARD_IGNORE_DIR} -type f -exec ls -1t "{}" +;) \
        | peek \
    )
    test -f "${FILE_TO_COPY}" && (cat ${FILE_TO_COPY} | pbcopy)
}

function pbcopy-from-shared-clipboard(){
	mkdir -p ${SHARED_CLIPBOARD_IGNORE_DIR}
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

function pbcopy-chrome-link() {
  chrome-links | fzf | pbcopy
}

function pbcopy-chrome-links() {
  chrome-links | pbcopy
}

function pbcopy-vscode-link() {
    find_files | fzf | gsed -E "s#^[.]/#${PWD}/#g" | vscode-link | tr -d '\n' | pbcopy
}

function pbcopy-iawriter-link() ( 
    find_iawriter_files | fzf | gsed -E "s#^#ia-writer://open?path=/Locations/#g" | tr -d '\n' | sed-url-encode | pbcopy 
)

function pbcopy-noteplan-shortcut() {
    noteplan-shortcuts | fzf | tr -d '\n' | pbcopy 
}

function pbcopy-noteplan-shortcuts() {
    noteplan-shortcuts | pbcopy
}

function pbcopy-glue-link() {
    glue-links | tr -d '\n' | pbcopy
}

alias pick=pbcopy-vscode-link
alias choose=pbcopy-vscode-link
