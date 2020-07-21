#!/bin/bash

# https://medium.com/better-programming/https-medium-com-ratik96-scheduling-jobs-with-crontab-on-macos-add5a8b26c30

LOGS_DIR=~/.logs

mkdir -p ${LOGS_DIR}

function update_shorcuts() {
  shortcuts update '#day'   "$(date +'%Y-%m-%d')"
  shortcuts update '#date'  "$(date +'%Y-%m-%d')"
  shortcuts update '#today' "$(date +'%Y-%m-%d')"
  shortcuts update '#td'    "$(date +'%Y-%m-%d')"
  shortcuts update '#yesterday' "$(date -v -1d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  shortcuts update '#yd' "$(date -v -1d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  shortcuts update '<1d' "$(date -v -1d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  shortcuts update '<2d' "$(date -v -2d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  shortcuts update '<1w' "$(date -v -7d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  shortcuts update '>1d' "$(date -v +1d +'>%Y-%m-%d') #usedShortcut"
  shortcuts update '>2d' "$(date -v +2d +'>%Y-%m-%d') #usedShortcut"
  shortcuts update '>1w' "$(date -v +7d +'>%Y-%m-%d') #usedShortcut"
  shortcuts update '#tm' "$(date -v +1d +'>%Y-%m-%d') #usedShortcut"
  shortcuts update '#tomorrow' "$(date -v +1d +'>%Y-%m-%d') #usedShortcut"
}

function main() {
  echo "Initiated Daily Cron as $(whoami)"
  update_shorcuts
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"Daily Cron\",\"/g" | sed 's/$/"/g'
}

main | prefix_logs >> ${LOGS_DIR}/cron.log
