# Every users writes into their own dir ...
export SHARED_CLIPBOARD_LOCATION=/Users/Shared/clipboard/$(get_other_user)/ingest
export SHARED_CLIPBOARD_IGNORE_DIR=/Users/Shared/clipboard/$(whoami)/ingested

function pbpaste-html() {
	pbpaste \
	| osascript -e 'the clipboard as «class HTML»' \
	| perl -ne 'print chr foreach unpack("C*",pack("H*",substr($_,11,-3)))'
}

function pbpaste-slack() {
	FILE=$(mktemp)
	pbpaste \
	  | strip-html.py \
	  | pandoc -f html -t markdown --wrap none --strip-comments --strip-empty-paragraphs \
	  | tee ${FILE} \
	  | bat -l markdown
	cat ${FILE} | pbcopy
	rm ${FILE}
}

function pbrm-from-shared-clipboard(){
	mkdir -p ${SHARED_CLIPBOARD_IGNORE_DIR}
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