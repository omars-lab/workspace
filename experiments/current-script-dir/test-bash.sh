#!/bin/bash

echo ${BASH_SOURCE[0]}
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo ${CURRENT_DIR}
test -L "${BASH_SOURCE[0]}" && echo LINK
ORIG_FILE=$(readlink "${BASH_SOURCE[0]}")
LINK_DIR="$( cd "$( dirname "${ORIG_FILE}" )" >/dev/null && pwd )"
echo ${LINK_DIR}
