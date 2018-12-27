#!/bin/bash

# Do not use this, funtions can be called from anywhere ...
# called=$_
# if [[ $called != $0 ]]
# then
#   echo "Script is being sourced"
#   IFTT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/ifttt"
# else
#   IFTT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# fi

IFTT_DIR=${DIRS_ENVIRONMENT}/ifttt

function maker() {
  echo curl -X POST -H "Content-Type: application/json" \
    -d "$(<${2:-${IFTT_DIR}/default.json})"  \
    https://maker.ifttt.com/trigger/$1/with/key/${IFTTT_KEY}
  curl -X POST -H "Content-Type: application/json" \
    -d "$(<${2:-${IFTT_DIR}/default.json})"  \
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
  $(<${IFTT_DIR}/default.jsontemplate)
  EOF" 2> /dev/null | head -n 1 > ${IFTT_DIR}/template.json
  maker $MAKEREVENT ${IFTT_DIR}/template.json
}

# EVENTTYPES="idea\nnote\ntought\nquote\nwork\nquran"
# echo -e $EVENTTYPES | xargs -I {} echo 'function {}() { maker_with_args track {} "$@" }' > ${IFTT_DIR}/functions.sh
# eval "$(cat ${IFTT_DIR}/functions.sh)"
