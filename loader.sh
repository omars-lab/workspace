#!/bin/bash

if [ -n "$ZSH_VERSION" ]; then
  echo ZSH Detected 1>&2
  CURRENT_DIR=${0:a:h}
  source ${CURRENT_DIR}/loader-zsh.sh
elif [ -n "$BASH_VERSION" ]; then
  echo BASH Detected 1>&2
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  source ${CURRENT_DIR}/loader-bash.sh
else
  echo NO VALID SHELL DETECTED 1>&2
  exit 1
fi
