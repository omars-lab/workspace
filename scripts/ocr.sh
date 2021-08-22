#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null 2>&1 && pwd )"
# DIR=/Users/omareid/Dropbox/Personal,Uncategorized
OUTPUT_DIR=${DIR}/ocred-text

cd "${DIR}" &&  find . -maxdepth 1 -name 'Screen Shot*' -exec bash -c 'test -f "${1}/${0}.txt" || tesseract "${0}" "${1}/${0}"' "{}" "${OUTPUT_DIR}" \;

