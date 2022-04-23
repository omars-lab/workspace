function github_curl() {
	PAS=$(secret github-access-token | pbpaste)
	curl -L -s \
		-H "Authorization: token ${PAS}" \
		-H 'Accept: application/vnd.github.v3.raw' \
		$@
}

function curl_shared_file() {
	curl -s -L https://www.dropbox.com/s/ihv2r6p0y7me76n/from-laptop.md?dl=1 \
		| bat --paging=never --language markdown --style plain
}
