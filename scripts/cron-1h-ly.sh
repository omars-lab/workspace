#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh

function main() {
  echo "Initiated 1h Cron as $(whoami)"
  ${DIR}/shortcuts-update.sh update_time_based_shorcuts
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"1h Cron\",\"/g" | sed 's/$/"/g'
}

main | prefix_logs >> ${LOGS_DIR}/cron.log
