#!/bin/bash

# https://medium.com/better-programming/https-medium-com-ratik96-scheduling-jobs-with-crontab-on-macos-add5a8b26c30

LOGS_DIR=~/.logs

mkdir -p ${LOGS_DIR}

function update_shorcuts() {
  shortcuts update '@day' "$(date +'%Y-%m-%d')"
}

function main() {
  echo "Initiated Daily Cron as $(whoami)"
  update_shorcuts
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%SZ")
  sed "s/^/${NOW},\"Daily Cron\",\"/g" | sed 's/$/"/g'
}


main | prefix_logs >> ${LOGS_DIR}/cron.log
