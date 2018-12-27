#!/bin/bash

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

eval "$(cat ${CURRENT_DIR}/variables.sh)"
source ${CURRENT_DIR}/common.sh >/dev/null

# NVM Stuff
export NVM_DIR=${DIR_FOR_BINARIES}/nvm
source $(brew --prefix nvm)/nvm.sh
