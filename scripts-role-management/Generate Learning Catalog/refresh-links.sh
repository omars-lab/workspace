#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LEARNING_CATALOG_DIR=${1:-.}
HATS_REPO_DIR=${2:-../..}
PREFIX=${3}

find ${LEARNING_CATALOG_DIR}/ -type l -exec unlink "{}" \; 
find ${HATS_REPO_DIR}/roles* -name "Learn*.md" -type f -exec "${SCRIPT_DIR}/link.sh" "${3}" "${LEARNING_CATALOG_DIR}" "{}" \;
find ${HATS_REPO_DIR}/roles* -name "Learn*.txt" -type f -exec "${SCRIPT_DIR}/link.sh" "${3}" "${LEARNING_CATALOG_DIR}" "{}" \;