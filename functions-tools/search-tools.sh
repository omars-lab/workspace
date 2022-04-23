# Search
function ag() {
	grep -rin $@ \
		--exclude '*.iml' \
		--exclude-dir build \
		--exclude-dir '.idea' \
		--exclude-dir '.git' \
		"${PWD}" \
		| gsed -E -e 's#^(.*):([0-9]+):(.*)#echo "vscode://file\1:\2" | sed -e "s: :%20:g" | tr -d "\n"; echo "\t\3"#ge'
}

function google() {
	# SEARCH_TERM=$(jq -nr --arg string "${@}" '$string|@uri')
	SEARCH_TERM=$@
	/Applications/Firefox.app/Contents/MacOS/firefox --search "${SEARCH_TERM}"
}

