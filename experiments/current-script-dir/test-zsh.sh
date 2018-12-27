#!/bin/zsh

echo ${0:a}
echo ${0:a:h}
echo ${(%):-%x}

CURRENT_DIR="$( cd "$( dirname "${0:a}" )" >/dev/null && pwd )"
echo ${CURRENT_DIR}
test -L "${0:a}" && echo LINK
ORIG_FILE=$(readlink "${0:a}")
LINK_DIR="$( cd "$( dirname "${ORIG_FILE}" )" >/dev/null && pwd )"
echo ${LINK_DIR}
