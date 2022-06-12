#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"

play_sound ${DIR}/../sounds/brilliant.mp3
