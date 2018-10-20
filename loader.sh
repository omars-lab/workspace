#!/bin/bash

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

if [ -n "$ZSH_VERSION" ]; then
  CURRENT_DIR=${0:a:h}
elif [ -n "$BASH_VERSION" ]; then
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
else
   exit 1
fi

eval "$(cat ${CURRENT_DIR}/variables.sh)"

# echo
source ${DIRS_ENVIRONMENT}/common.sh >/dev/null
# echo -n -e "\e[0K\r [ 1 / 8] Loaded common.sh"
source ${DIRS_ENVIRONMENT}/envmgr/envmgr.sh
source ${DIRS_ENVIRONMENT}/theme.sh
source ${DIRS_ENVIRONMENT}/ifttt/maker.sh
source ${DIRS_ENVIRONMENT}/ifttt/functions.sh

recursive-source ${DIRS_ENVIRONMENT} "loader|common|theme|bookmarks"
recursive-source ${DIRS_ENVIRONMENT}/commands
recursive-source ${DIRS_ENVIRONMENT}/aliases

# Python Virtual Env Stuff (Using Conda Instead ...)
# export WORKON_HOME=${DIRS_VIRTUAL_ENVS}
# export VIRTUALENVWRAPPER_PYTHON="${DIRS_VIRTUAL_ENVS}/cogenv/bin/python"
# source $(which virtualenvwrapper.sh)

# export PATH="$PATH:$VIRTUAL_ENV/bin"
# echo ${VIRTUAL_ENV##*/} | grep 'cogenv' || workon cogenv  # virtualenvwrapper command

# NVM Stuff
export NVM_DIR=${DIR_FOR_BINARIES}/nvm
source $(brew --prefix nvm)/nvm.sh

# Setup the env
# envmgr use omarstest
