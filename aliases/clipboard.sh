# Every users writes into their own dir ...
export SHARED_CLIPBOARD_LOCATION=/Users/Shared/clipboard/$(get_other_user)/ingest
export SHARED_CLIPBOARD_IGNORE_DIR=/Users/Shared/clipboard/$(whoami)/ingested
mkdir -p ${SHARED_CLIPBOARD_IGNORE_DIR}


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
