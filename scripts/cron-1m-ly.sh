#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh

function play_athan() {
  # List active networks. ..
  WIFI_NAME='ATT3XxQF24'
  ACTIVE_INTERFACE=$(ifconfig | grep -E -e '^[a-zA-Z]' -e '\s+status' | sed -E -e 's/^([a-zA-Z][^:]+): .*/\1/g' | grep -B 1 'status: active' | grep -o '^[a-zA-Z].*' | grep en)
  REPO_ROOT=$(cd "${DIR}" && git rev-parse --show-toplevel)
  ATHAN_DIR=${REPO_ROOT}/../athan/
  # - [ensure connection to wifi ...](https://www.techrepublic.com/article/pro-tip-manage-wi-fi-with-terminal-commands-on-os-x/)
  ( networksetup -getairportnetwork ${ACTIVE_INTERFACE} | grep ${WIFI_NAME} ) || ( networksetup -setairportnetwork ${ACTIVE_INTERFACE} ${WIFI_NAME} && echo Connected to WiFi )
  cd "${ATHAN_DIR}" && ./athan 2>&1
}

function all {
  # ${DIR}/check-disneyworld.sh
  # ${DIR}/notify-iphone.sh
  # ${DIR}/check-fridge.sh
  echo Stuff
  true
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"1m Cron\",\"/g" | sed 's/$/"/g'
}

function main() (
  echo "Initiated 1m Cron as $(whoami)"
  # Do specific things on specific computers ...
  case ${SERIAL_NUMBER} in
    # Mac Mini ...
    H2WDR1UWQ6NV)
      play_athan
    ;;
    *)
    ;;
  esac
)

main | prefix_logs >> ${LOGS_DIR}/cron.log
