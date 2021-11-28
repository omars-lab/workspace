#!/bin/bash

# ATHAN_FILE=$(ls ${HOME}/Dropbox*/Personal,Uncategorized/58b0dac02106f.mp3)
SURAT_ALBAQARAH='https://www.youtube.com/watch?v=ieHCmmiYKIQ'
MORNING_ATHKAR='https://www.youtube.com/watch?v=V2Brp_esIVI'

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
  ${speaker} volume ${AUDIO_LEVEL}
  ${speaker} cast "${URL}" &
}

function pause_audio_players() {
  scan_players | xargs -I {} catt -d {} stop
}
