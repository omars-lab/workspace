#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"
conda activate workspace

function update_shortcuts() {

  # DONE="$(date +'@done(%Y-%m-%d %H:%M %p)') #usedShortcut"
  # BINNED_NOW=$(date +'%Y-%m-%dT%H:00:00%z')

  # shortcuts-clean.sh "hour"
  # shortcuts-clean.sh "now"
  # shortcuts-clean.sh "done"

  # sleep 1 

  # /usr/local/bin/shortcuts update '#hour' "${BINNED_NOW}"
  # /usr/local/bin/shortcuts update '@hour' "${BINNED_NOW}"
  # /usr/local/bin/shortcuts update '>hour' "${BINNED_NOW}"

  # /usr/local/bin/shortcuts update '#now' "${BINNED_NOW}"
  # /usr/local/bin/shortcuts update '@now' "${BINNED_NOW}"
  # /usr/local/bin/shortcuts update '>now' "${BINNED_NOW}"

  # /usr/local/bin/shortcuts update '#done' "${DONE}"
  # /usr/local/bin/shortcuts update '>done' "${DONE}"
  
  # Results in cyclic deps with noteplan when shifting ...
  # /usr/local/bin/shortcuts update '@done' "${DONE}"
  
  true
}

function main() {
  echo "Initiated 5m Cron as $(whoami)"
  update_shortcuts
  echo "Done updating hourly shortcuts"
}

# Do specific things on specific computers ...
case ${SERIAL_NUMBER} in
  # Mac Mini ...
  H2WDR1UWQ6NV)
    run_cron_job "5m"
  ;;
  *)
    log.debug "Nothing to do ..."
  ;;
esac

# ( main | prefix_logs ) 2>>${LOGS_DIR}/cron.error.log 1>>${LOGS_DIR}/cron.log
