function first(){
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
