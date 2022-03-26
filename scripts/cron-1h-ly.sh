#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"

function main() {
  echo "Initiated 1h Cron as $(whoami)"
  ${DIR}/shortcuts-update.sh update_time_based_shorcuts
}

# Do specific things on specific computers ...
case ${SERIAL_NUMBER} in
  # Mac Mini ...
  H2WDR1UWQ6NV)
    run_cron_job "1h"
  ;;
  *)
  ;;
esac
# main | prefix_logs >> ${LOGS_DIR}/cron.log
