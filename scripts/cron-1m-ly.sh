#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"
REPO_ROOT=$(git -C "${DIR}" rev-parse --show-toplevel)
WIFI_NETWORK=ATT3XxQF24

function is_ethernet() {
  networksetup -listallhardwareports | grep ${1} -B1 | grep Ethernet
}

function get_active_interface() {  
  # Gets the first active interface ... could be ethernet ... could be wifi ...
  # ... to determine if a port is wif or ethernet ... i could possibly use the following:
  #   https://www.tweaking4all.com/forum/macos-x-software/macos-finding-active-ethernet-wifi-ports-with-ifconfig/
  #   networksetup -listnetworkserviceorder
  ifconfig \
    | grep -E -e '^[a-zA-Z]' -e '\s+status' \
    | sed -E -e 's/^([a-zA-Z][^:]+): .*/\1/g' \
    | grep -B 1 'status: active' \
    | grep -o '^[a-zA-Z].*' \
    | grep en \
    | head -n 1
}

function ensure_wifi_connection() {
  WIFI_NAME="${1}"
  ACTIVE_INTERFACE=$(get_active_interface)
  ( networksetup -getairportnetwork ${ACTIVE_INTERFACE} | grep ${WIFI_NAME} ) \
    || ( networksetup -setairportnetwork ${ACTIVE_INTERFACE} ${WIFI_NAME} && echo Connected to WiFi )
}

function ensure_connected() {
  # List active networks. ..
  WIFI_NAME="${1}"
  ACTIVE_INTERFACE=$(get_active_interface)
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

function main() (
  echo "Initiated 1m Cron as $(whoami)"
  # Moved athan to launctrl
  # play_athan
  # play_quran
  ${DIR}/check-apis.sh
  git -C "${REPO_ROOT}" pull
  # run-homeassistant.sh
  # all
)

# Do specific things on specific computers ...
case ${SERIAL_NUMBER} in
  # Mac Mini ...
  H2WDR1UWQ6NV)
    run_cron_job "1m"
  ;;
  *)
    log.debug "Nothing to do ..."
  ;;
esac

# ( main | prefix_logs ) 1>>${LOGS_DIR}/cron.log 2>>${LOGS_DIR}/cron.error.log
