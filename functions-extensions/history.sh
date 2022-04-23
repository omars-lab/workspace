# History
function history_unique_commands() {
	history | \
	grep -E -v \
	'^\s*[0-9]+\s*(ls|rm|todo|secret|history|grep|cd|ag|vi|man|mv|[.]+|make|python|cat|brazil|vscode|brew|open|pbpaste|which|x |mkdir|rehash|jq|curl|cp)'
}

function zsh_history() {
    # https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x
    # ^^^^^^^^ justifies ||||||||||
    cat ~/.zsh_history | LC_CTYPE=C sed -E 's/^[: 0-9]+[;]//g'
}

function bash_history() {
    cat ~/.bash_history
}

function history_file() {
    test "${DETECTED_SHELL}" = "ZSH" && zsh_history || bash_history
}

function history-clean(){
    echo "---------- History ----------"
    history_file | \
      tail -n 10000 | \
      grep -ve "^\s*cd"	    | \
      grep -ve "^\s*ls"	    | \
      grep -ve "^\s*clear"	| \
      grep -ve "^\s*subl"	| \
      grep -ve "^\s*vi"	    | \
      grep -ve "^\s*cat"	| \
      grep -ve "^\s*atom"	| \
      grep -ve "^\s*pwd"	| \
      grep -ve '^\s*\w\+$'
      # LC_CTYPE=C sort
      # uniq -c
}

if [[ "${DETECTED_SHELL}" = "BASH" ]]
then
    export -f history-clean
    export -f history_unique_commands
    export -f zsh_history
    export -f bash_history
    export -f history_file
fi
