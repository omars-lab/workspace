#!/bin/bash

# https://medium.com/better-programming/https-medium-com-ratik96-scheduling-jobs-with-crontab-on-macos-add5a8b26c30

LOGS_DIR=~/.logs

mkdir -p ${LOGS_DIR}


function update_shortcuts() {
  shortcuts update '@hour' "$(date +'%Y-%m-%dT%H:00:00%z')"
  shortcuts update '@done' "$(date +'@done(%Y-%m-%d %H:%M %p)')"
}

function main() {
  echo "Initiated Hourly Cron as $(whoami)"
  update_shortcuts
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"Hourly Cron\",\"/g" | sed 's/$/"/g'
}


main | prefix_logs >> ${LOGS_DIR}/cron.log
