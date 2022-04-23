# History
function history_unique_commands() {
	history | \
	grep -E -v \
	'^\s*[0-9]+\s*(ls|rm|todo|secret|history|grep|cd|ag|vi|man|mv|[.]+|make|python|cat|brazil|vscode|brew|open|pbpaste|which|x |mkdir|rehash|jq|curl|cp)'
}
