function glue-links() {
    jq -r 'def netloc: (input_filename|gsub(".*glue.";"")|gsub(".json";"")); keys | .[] | "glue://\(netloc)/\(.)"' \
        /Applications/Glue.app/Contents/Resources/Scripts/glue.*.json \
        | fzf --preview "/Applications/Glue.app/Contents/Resources/Scripts/glue-resolver {}" --color light --margin 5,20
}   

# jq -c 'to_entries|.[]|{file: input_filename|gsub(".*glue.";"")|gsub(".json";""), key:.key}' /Applications/Glue.app/Contents/Resources/Scripts/glue.*.json