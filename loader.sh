function resolve_link() {
	LINK="${1}"
	test -L "${LINK}" && readlink "${LINK}" || echo "${LINK}"
}

if [ -n "$ZSH_VERSION" ]; then
  echo ZSH Detected 1>&2
  export DETECTED_SHELL=ZSH
  # https://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
  SCRIPT_FILE=${(%):-%x}
  export CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"
  export LOADER_SCRIPT="${CURRENT_DIR}/loader-zsh.sh"
elif [ -n "$BASH_VERSION" ]; then
  echo BASH Detected 1>&2
  export DETECTED_SHELL=BASH
  SCRIPT_FILE=$(resolve_link "${BASH_SOURCE[0]}")
  export CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"
  export LOADER_SCRIPT="${CURRENT_DIR}/loader-bash.sh"
else
  echo NO VALID SHELL DETECTED 1>&2
  exit 1
fi

echo Sourcing "${LOADER_SCRIPT}"
source ${LOADER_SCRIPT}
