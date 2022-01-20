#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source ${DIR}/cron-common.sh
source ${DIR}/functions.sh
PATH="${DIR}:${PATH}"
conda activate homeassistant

function start_homeassistant() {
	# https://en.wikipedia.org/wiki/Nohup
	nohup hass 1>>${HOME}/.logs/homeassistant.log 2>>${HOME}/.logs/homeassistant.error.log < /dev/null &
}

is_running hass || start_homeassistant

