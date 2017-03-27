#!/bin/bash

# Do not use this, funtions can be called from anywhere ...
# called=$_
# if [[ $called != $0 ]]
# then
#   echo "Script is being sourced"
#   CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/ifttt"
# else
#   CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# fi

CURRENT_DIR=${DIRS_ENVIRONMENT}/ifttt

function maker() {
  echo curl -X POST -H "Content-Type: application/json" \
    -d "$(<${2:-${CURRENT_DIR}/default.json})"  \
    https://maker.ifttt.com/trigger/$1/with/key/${IFTTT_KEY}
  curl -X POST -H "Content-Type: application/json" \
    -d "$(<${2:-${CURRENT_DIR}/default.json})"  \
    https://maker.ifttt.com/trigger/$1/with/key/${IFTTT_KEY}
}

function maker_with_args() {
  export MAKEREVENT=${1}
  shift
  export VALUE1=${1:-""}
  shift
  export VALUE2="$*"
  export VALUE3="$(date)"

  eval "cat <<EOF
  $(<${CURRENT_DIR}/default.jsontemplate)
  EOF" 2> /dev/null | head -n 1 > ${CURRENT_DIR}/template.json
  maker $MAKEREVENT ${CURRENT_DIR}/template.json
}

# EVENTTYPES="idea\nnote\ntought\nquote\nwork\nquran"
# echo -e $EVENTTYPES | xargs -I {} echo 'function {}() { maker_with_args track {} "$@" }' > ${CURRENT_DIR}/functions.sh
# eval "$(cat ${CURRENT_DIR}/functions.sh)"
