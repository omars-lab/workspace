#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh

function update_shortcuts() {

  DONE="$(date +'@done(%Y-%m-%d %H:%M %p)') #usedShortcut"
  BINNED_NOW=$(date +'%Y-%m-%dT%H:00:00%z')

  ${DIR}/clean-shortcuts.sh "hour"
  ${DIR}/clean-shortcuts.sh "now"
  ${DIR}/clean-shortcuts.sh "done"

  sleep 1 

  /usr/local/bin/shortcuts update '#hour' "${BINNED_NOW}"
  /usr/local/bin/shortcuts update '@hour' "${BINNED_NOW}"
  /usr/local/bin/shortcuts update '>hour' "${BINNED_NOW}"

  /usr/local/bin/shortcuts update '#now' "${BINNED_NOW}"
  /usr/local/bin/shortcuts update '@now' "${BINNED_NOW}"
  /usr/local/bin/shortcuts update '>now' "${BINNED_NOW}"

  /usr/local/bin/shortcuts update '#done' "${DONE}"
  /usr/local/bin/shortcuts update '>done' "${DONE}"
  # Results in cyclic deps with noteplan when shifting ...
  # /usr/local/bin/shortcuts update '@done' "${DONE}"

}

function main() {
  echo "Initiated 5m Cron as $(whoami)"
  update_shortcuts
  echo "Done updating hourly shortcuts"
  instock-alerts
  echo "Done generating instock alerts"
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"5m Cron\",\"/g" | sed 's/$/"/g'
}

main | prefix_logs >> ${LOGS_DIR}/cron.log
