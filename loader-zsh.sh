#!/bin/bash

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

eval "$(cat ${CURRENT_DIR}/variables.sh)"

source ${DIRS_ENVIRONMENT}/common.sh >/dev/null
source ${DIRS_ENVIRONMENT}/envmgr/envmgr.sh
source ${DIRS_ENVIRONMENT}/theme.sh
source ${DIRS_ENVIRONMENT}/ifttt/maker.sh
source ${DIRS_ENVIRONMENT}/ifttt/functions.sh

recursive_source ${DIRS_ENVIRONMENT} "loader|common|theme|bookmarks"
recursive_source ${DIRS_ENVIRONMENT}/commands
recursive_source ${DIRS_ENVIRONMENT}/aliases

export NVM_DIR=${DIR_FOR_BINARIES}/nvm
source $(brew --prefix nvm)/nvm.sh
