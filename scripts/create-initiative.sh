#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

function file_fullpath_from_summary() {
    FILENAME=$(echo "${1}" | jq -Rr 'ascii_downcase|gsub("[:]"; "")|gsub(" "; "-")')
    echo "${DIR}/../../blueprints/initiatives/${FILENAME}.md"
}

function append_content_to_initiatives_file() {
    FULLPATH="${1}"
    URL="${2}"
    SUMMARY="${3}"
    echo '---' > "${FULLPATH}"
    echo "jira: ${URL}" >> "${FULLPATH}"
    echo '---' >> "${FULLPATH}"
    echo '' >> "${FULLPATH}"
    echo "# ${SUMMARY}" >> "${FULLPATH}"
    echo '' >> "${FULLPATH}"
}

function init_initiatives_file() {
    FULLPATH="${1}"
    URL="${2}"
    SUMMARY="${3}"
    test -f "${FULLPATH}" || append_content_to_initiatives_file "${FULLPATH}" "${URL}" "${SUMMARY}"
}

SUMMARY="${1:?ARG1 required as summary.}"
INITIATIVES_FILE=$(file_fullpath_from_summary "${SUMMARY}")
NEW_URL=$(\
    ${DIR}/../../automatic-cloud-backup/jira-helpers.sh create "${SUMMARY}" \
        | jq -r '"https://sacred-patterns.atlassian.net/browse/\(.key)"' \
)

init_initiatives_file "${INITIATIVES_FILE}" "${NEW_URL}" "${SUMMARY}"
