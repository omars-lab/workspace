function resolve_link() {
	LINK="${1}"
	test -L "${LINK}" && readlink "${LINK}" || echo "${LINK}"
}

if [ -n "$ZSH_VERSION" ]; then
  [[ "${DEBUG_LOADER:-false}" == "true" ]] && echo ZSH Detected 1>&2
  export DETECTED_SHELL=ZSH
  # https://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
  SCRIPT_FILE=${(%):-%x}
  export CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"
  export LOADER_SCRIPT="${CURRENT_DIR}/loader-personal.sh"
elif [ -n "$BASH_VERSION" ]; then
  [[ "${DEBUG_LOADER:-false}" == "true" ]] && echo BASH Detected 1>&2
  export DETECTED_SHELL=BASH
  SCRIPT_FILE=$(resolve_link "${BASH_SOURCE[0]}")
  export CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"
  export LOADER_SCRIPT="${CURRENT_DIR}/loader-personal.sh"
else
  echo NO VALID SHELL DETECTED 1>&2
  exit 1
fi

[[ "${DEBUG_LOADER:-false}" == "true" ]] && echo Sourcing "${LOADER_SCRIPT}" >&2
source ${LOADER_SCRIPT}
