function first(){
  # picks the first valid file ... recrsively ...
  if [[ "$#" == "0" ]]; then
    echo "No files satisfied" >&2
    return
  fi

  if [[ -f "${1}" ]]; then
    echo "${1}"
    return
  fi

  if [[ -d "${1}" ]]; then
    echo "${1}"
    return
  fi

  shift
  first $@
}

function age() {
	local FILE="${1}"
	echo $(( $(date +%s) - $(stat -t %s -f %m -- "${FILE}") ))
}

function check_if_exists() {
	echo "Checking if '${1}' exists." >&2
	test -d "${1}"
}