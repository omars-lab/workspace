#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${CURRENT_DIR}/common.sh

ICLOUD_ROOT=$(echo ${HOME}'/Library/Mobile Documents')
ICLOUD_EMAIL=$(cat "${ICLOUD_ROOT}/email.txt")
echo ${ICLOUD_EMAIL}

NOTEPLAN_ICLOUD_DIR="${ICLOUD_ROOT}/iCloud~co~noteplan~NotePlan/Documents"
NOTEPLAN_GIT_DIR="${CURRENT_DIR}/iCloud/${ICLOUD_EMAIL}/Noteplan"

LIGHT_CYAN='\033[1;36m'
NC='\033[0m'

function backup_noteplan()(
    printf "${LIGHT_CYAN}Backing Up NotePlan ...${NC}\n"
    NAME_OF_ZIP="${CURRENT_DIR}/iCloud/${ICLOUD_EMAIL}/archives/noteplan-$(date +"%Y-%m-%dT%H-%M-%S").zip"
    create_zip_WITH_NAME_relavtive_to_DIR_recrusively "${NAME_OF_ZIP}" "${NOTEPLAN_ICLOUD_DIR}/"
    # - [ ] Add log rotate ...
)

function backup_from_noteplan_to_git(){
    mkdir -p "${NOTEPLAN_GIT_DIR}"
    # unison "${NOTEPLAN_ICLOUD_DIR}" "${NOTEPLAN_GIT_DIR}"
    rsync -arv --exclude='*.DS_Store*' --exclude='*.Trash*' --exclude='*.icloud*' "${NOTEPLAN_ICLOUD_DIR}" "${NOTEPLAN_GIT_DIR}"
}

backup_noteplan \
    && backup_from_noteplan_to_git
