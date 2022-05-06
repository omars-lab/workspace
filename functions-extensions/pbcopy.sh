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

function pbcopy-chrome-links() {
  chrome-cli list links | sed -E -e 's/^\[([0-9]+):([0-9]+)\] (.*)/\3/g' | optionally_filter "${1}" | pbcopy
}

function pbcopy-vscode-link() {
    find . -type f -depth 2 | fzf | gsed -E "s#^[.]/#${PWD}/#g" | vscode-link | tr -d '\n' | pbcopy
}

alias pick=pbcopy-vscode-link
alias choose=pbcopy-vscode-link
