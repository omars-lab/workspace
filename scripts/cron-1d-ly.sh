#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"

function main() {
  echo "Initiated 1d Cron as $(whoami)"
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"1d Cron\",\"/g" | sed 's/$/"/g'
}

( main | prefix_logs ) 1>>${LOGS_DIR}/cron.log 2>>${LOGS_DIR}/cron.error.log 
