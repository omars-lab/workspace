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
  export LOADER_SCRIPT="${CURRENT_DIR}/loader-brew.sh"
elif [ -n "$BASH_VERSION" ]; then
  echo BASH Detected 1>&2
  export DETECTED_SHELL=BASH
  SCRIPT_FILE=$(resolve_link "${BASH_SOURCE[0]}")
  export CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"
  export LOADER_SCRIPT="${CURRENT_DIR}/loader-brew.sh"
else
  echo NO VALID SHELL DETECTED 1>&2
  exit 1
fi

#  - [ ] Make shared variables ...
#  - [ ] auto make noteplan link ...

test -d ${HOME}/Library/Mobile\ Documents/iCloud~co~noteplan~NotePlan/Documents && \
    ! (test -L ${HOME}/.noteplan) && \
    ln -s ${HOME}/Library/Mobile\ Documents/iCloud~co~noteplan~NotePlan/Documents ${HOME}/.noteplan

# - [ ] Todo ... add work location here ... but prefer icloud ...

NOTEPLAN_HOME=${HOME}/.noteplan

echo Sourcing "${LOADER_SCRIPT}" >&2
source ${LOADER_SCRIPT}
