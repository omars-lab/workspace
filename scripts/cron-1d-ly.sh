#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"

function main() {
  echo "Initiated 1d Cron as $(whoami)"
}

run_cron_job "1d"
# ( main | prefix_logs ) 1>>${LOGS_DIR}/cron.log 2>>${LOGS_DIR}/cron.error.log 
