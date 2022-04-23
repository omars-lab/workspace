function age() {
	local FILE="${1}"
	echo $(( $(date +%s) - $(stat -t %s -f %m -- "${FILE}") ))
}

function check_if_exists() {
	echo "Checking if '${1}' exists." >&2
	test -d "${1}"
}