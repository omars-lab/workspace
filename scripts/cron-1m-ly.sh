#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
REPO_ROOT=$(cd "${DIR}" && git rev-parse --show-toplevel)

function ensure_wifi_connection() {
  # List active networks. ..
  WIFI_NAME="${1}"
  ACTIVE_INTERFACE=$(ifconfig | grep -E -e '^[a-zA-Z]' -e '\s+status' | sed -E -e 's/^([a-zA-Z][^:]+): .*/\1/g' | grep -B 1 'status: active' | grep -o '^[a-zA-Z].*' | grep en)
  # - [ensure connection to wifi ...](https://www.techrepublic.com/article/pro-tip-manage-wi-fi-with-terminal-commands-on-os-x/)
  ( networksetup -getairportnetwork ${ACTIVE_INTERFACE} | grep ${WIFI_NAME} ) || ( networksetup -setairportnetwork ${ACTIVE_INTERFACE} ${WIFI_NAME} && echo Connected to WiFi )
}

function play_athan() {
  ensure_wifi_connection 'ATT3XxQF24'
  cd "${REPO_ROOT}/../athan/" && ./athan 2>&1
}

function play_quran() {
  ensure_wifi_connection 'ATT3XxQF24'
  cd "${REPO_ROOT}/../athan/" && ./athan 2>&1
}

function all {
  # ${DIR}/check-disneyworld.sh
  # ${DIR}/notify-iphone.sh
  # ${DIR}/check-fridge.sh
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
      git pull
    ;;
    *)
    ;;
  esac
  all
)

main | prefix_logs >> ${LOGS_DIR}/cron.log
