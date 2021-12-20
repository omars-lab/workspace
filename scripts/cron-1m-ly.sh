#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"
REPO_ROOT=$(git -C "${DIR}" rev-parse --show-toplevel)

WIFI_NETWORK=ATT3XxQF24

function is_ethernet() {
  networksetup -listallhardwareports | grep ${1} -B1 | grep Ethernet
}

function ensure_wifi_connection() {
  ( networksetup -getairportnetwork ${ACTIVE_INTERFACE} | grep ${WIFI_NAME} ) \
    || ( networksetup -setairportnetwork ${ACTIVE_INTERFACE} ${WIFI_NAME} && echo Connected to WiFi )
}

function ensure_connected() {
  # List active networks. ..
  WIFI_NAME="${1}"
  ACTIVE_INTERFACE=$(ifconfig | grep -E -e '^[a-zA-Z]' -e '\s+status' | sed -E -e 's/^([a-zA-Z][^:]+): .*/\1/g' | grep -B 1 'status: active' | grep -o '^[a-zA-Z].*' | grep en)
  # - [ensure connection to wifi ...](https://www.techrepublic.com/article/pro-tip-manage-wi-fi-with-terminal-commands-on-os-x/)
  is_ethernet ${ACTIVE_INTERFACE} || ensure_wifi_connection "${WIFI_NETWORK}"
}

function play_athan() {
  ensure_connected
  ( cd "${REPO_ROOT}/../athan/" && ./athan 2>&1 )
}

function play_quran() {
  ensure_connected
  ${DIR}/cron-player.sh
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
      play_quran
      ${DIR}/check-apis.sh
      git -C "${REPO_ROOT}" pull
    ;;
    *)
    ;;
  esac
  all
)

( main | prefix_logs ) 1>>${LOGS_DIR}/cron.log 2>>${LOGS_DIR}/cron.error.log
