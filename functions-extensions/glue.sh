function glue-def() {
    GLUE_LINK=${1}
    FILEKEY=basename $(dirname "${1}")
    JSONKEY=$(basename "${1}")
    jq -r --arg key ${JSONKEY} '.[$key]' /Applications/Glue.app/Contents/Resources/Scripts/glue.${FILEKEY}.json
}

function glue-links() {
    jq -r 'def netloc: (input_filename|gsub(".*glue.";"")|gsub(".json";"")); keys | .[] | "glue://\(netloc)/\(.)"' \
        /Applications/Glue.app/Contents/Resources/Scripts/glue.*.json \ 
    | fzf --preview "glue-def {}" --color light --margin 5,20
}   