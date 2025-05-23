#!/bin/bash

PREFIX=${1}
CATALOG_DIR=${2}

function craft_link_name() {
  sed 's/from /From /g' \
  | sed 's/about /About /g' \
  | sed -E 's#.*/role[a-zA-Z-]*/The ([^/]+)(/|(.*)/)([^/]+).(txt|md)#\4-AsA\1.\5#' \
  | sed 's#[ ]##g' \
  | sed 's#/#-#g'
}

cd "${CATALOG_DIR}"

FILE="${3}"
LINK=$(echo "${FILE}" | craft_link_name)

# test -L "${LINK}" && unlink "${LINK}"
ln -s "${PREFIX}${FILE}" "${LINK}" 
