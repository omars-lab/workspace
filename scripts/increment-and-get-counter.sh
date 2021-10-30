#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
COUNTER_NAME=${1:?ARG1=Counter Name}
COUNTER_FILE=${HOME}/Dropbox/counters/${COUNTER_NAME}.txt
test -f "${COUNTER_FILE}" || (echo 0 > ${COUNTER_FILE})
expr $(cat "${COUNTER_FILE}") "+" 1 > "${COUNTER_FILE}"
# echo -n "${COUNTER_FILE}: " >&2 
cat "${COUNTER_FILE}"
