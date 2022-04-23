function clean_lines() {
    # https://stackoverflow.com/questions/23816264/remove-all-special-characters-and-case-from-string-in-bash
    tr -dc '[:alnum:]\n'
}

function wrap_lines_in_single_quotes() {
    clean_lines | jq -Rr '"'"'"'\(.)'"'"'"'
}
