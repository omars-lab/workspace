#!/bin/zsh

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

# SCRIPT_FILE=${(%):-%x}
# CURRENT_DIR="$( cd "$( dirname "${SCRIPT_FILE}" )" >/dev/null && pwd )"

which brew && ( ( brew tap | grep -q omars-lab) || brew tap omars-lab/tap )

# eval "$(cat ${CURRENT_DIR}/variables.sh)"
source ${CURRENT_DIR}/loader-variables.sh
source ${CURRENT_DIR}/common.sh >/dev/null
source ${CURRENT_DIR}/envmgr/envmgr.sh
source ${CURRENT_DIR}/ifttt/maker.sh
source ${CURRENT_DIR}/ifttt/functions.sh
source ${CURRENT_DIR}/themes/theme.sh
source ${CURRENT_DIR}/loader-variables.sh

# echo Starting Catchall Sourcer >&2
# SILENT=false recursive_source ${CURRENT_DIR} "loader|common|theme|bookmarks|setup"
# echo Done Catchall Sourcer >&2

recursive_source ${CURRENT_DIR}/functions-personal
