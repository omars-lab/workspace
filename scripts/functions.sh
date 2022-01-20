#!/bin/bash

function retry() {
	COUNTER=${2:-1}
	echo Trying ${COUNTER} more times >&2
	if [[ "${COUNTER}" -gt 0 ]]
	then
		eval "${1}" || ( sleep 5 && retry "${1}" $(expr "${COUNTER}" - 1) )
	else 
		false
	fi
}

function scan_players() {
  # IP=192.168.1.249
  # IP=$(catt scan -j | jq -r 'to_entries | .[] | .value.ip')
  # jq -nr ' [{"ip":123}] | if (length == 0) then ( null | halt_error(1) ) else ( to_entries | .[] | .value.ip ) end'
  # jq -nr ' [] | if (length == 0) then ( null | halt_error(1) ) else ( to_entries | .[] | .value.ip ) end'
  retry "catt scan -j | jq -r ' if (length == 0) then ( null | halt_error(1) ) else ( to_entries | .[] | .value.ip ) end'" 3
}

function play_audio_from_url() {
  URL="${1}"
  # IP Needs to be last argument ... since its being provided by xargs ...
  IP="${2}"
  AUDIO_LEVEL=${AUDIO_LEVEL:-50}
  speaker="catt -d ${IP}"
  ${speaker} stop
  sleep 2
  ${speaker} volume ${AUDIO_LEVEL}
  sleep 2
  ${speaker} cast "${URL}" &
}

function pause_audio_players() {
  scan_players | xargs -I {} catt -d {} stop
}

function is_running() {
	# https://stackoverflow.com/questions/2159860/viewing-full-output-of-ps-command
	# https://stackoverflow.com/questions/26619477/how-to-get-output-to-show-only-cmd-with-ps-u-username
	ps -ae -wo command | grep -v grep | grep -q "${@}"
}
