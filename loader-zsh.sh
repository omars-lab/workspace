#!/bin/zsh

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

# SCRIPT_FILE=${(%):-%x}
# CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"

eval "$(cat ${CURRENT_DIR}/variables.sh)"

source ${CURRENT_DIR}/common.sh >/dev/null
source ${CURRENT_DIR}/envmgr/envmgr.sh
source ${CURRENT_DIR}/theme.sh
source ${CURRENT_DIR}/ifttt/maker.sh
source ${CURRENT_DIR}/ifttt/functions.sh

recursive_source ${CURRENT_DIR} "loader|common|theme|bookmarks|setup"
recursive_source ${CURRENT_DIR}/commands
recursive_source ${CURRENT_DIR}/functions

