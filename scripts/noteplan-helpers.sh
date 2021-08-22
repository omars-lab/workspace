#!/bin/bash

# export PERSONAL_ICLOUD_DIR="/Users/omareid/Library/Mobile Documents"
# export PERSONAL_ICLOUD_NOTEPLAN_DIR="${PERSONAL_ICLOUD_DIR}/iCloud~co~noteplan~NotePlan/Documents"

export PERSONAL_ICLOUD_DIR="${HOME}/Library/Mobile Documents"
export PERSONAL_ICLOUD_NOTEPLAN_DIR="${NOTEPLAN_ICLOUD_DIR}"

function parse_from_noteplan_date() {
  DATE_TO_PARSE=$(echo ${1} | sed -e 's/.txt//g')
  # echo ${DATE_TO_PARSE} >&2
  date -jf "%Y%m%d" '+%Y-%m-%d.txt' "${DATE_TO_PARSE}"
}

function parse_to_noteplan_date() {
  DATE_TO_PARSE=$(echo ${1} | sed -e 's/.txt//g')
  # echo ${DATE_TO_PARSE} >&2
  date -jf "%Y-%m-%d" '+%Y%m%d.txt' "${DATE_TO_PARSE}"
}

function noteplan_date_to_noteplan_calendar_file(){
  NOTEPLAN_FORMATED_DATE_TO_EDIT=$(parse_to_noteplan_date "${1}")
  echo "${PERSONAL_ICLOUD_NOTEPLAN_DIR}/Calendar/${NOTEPLAN_FORMATED_DATE_TO_EDIT}"
}

function preview_noteplan_date_file(){
  NOTEPLAN_FILE=$(noteplan_date_to_noteplan_calendar_file "$1")
  head -$LINES "${NOTEPLAN_FILE}"
}

export -f parse_from_noteplan_date
export -f parse_to_noteplan_date
export -f noteplan_date_to_noteplan_calendar_file
export -f preview_noteplan_date_file
