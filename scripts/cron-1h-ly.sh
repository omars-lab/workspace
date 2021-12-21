#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"

function main() {
  echo "Initiated 1h Cron as $(whoami)"
  ${DIR}/shortcuts-update.sh update_time_based_shorcuts
}

run_cron_job "1h"
# main | prefix_logs >> ${LOGS_DIR}/cron.log
