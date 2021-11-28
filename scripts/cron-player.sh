#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
source ${DIR}/functions.sh
PATH="${DIR}:${PATH}"
conda activate workspace

# https://rimuhosting.com/knowledgebase/linux/misc/trapping-ctrl-c-in-bash
# trap ctrl-c and call pause_audio_players() 
trap pause_audio_players INT

function play_athkar() {
  scan_players \
    | xargs -n 1 bash -c 'source ${0}/functions.sh; AUDIO_LEVEL=15 play_audio_from_url "${1}" "${2}"' "${DIR}" "${MORNING_ATHKAR}"
}

function play_surat_albaqarah() {
  scan_players \
    | xargs -n 1 bash -c 'source ${0}/functions.sh; AUDIO_LEVEL=15 play_audio_from_url "${1}" "${2}"' "${DIR}" "${SURAT_ALBAQARAH}"
}

NOW=$(date +"%I:%M%p")
echo "Playing audio files configured for ... ${NOW}"
case "${NOW}" in
  08:00AM)
    play_athkar
  ;;
  08:15AM)
    play_surat_albaqarah
  ;;
esac

# downloading athan
# youtube-dl -x --audio-format mp3 https://www.youtube.com/watch\?v\=iaWZ_3D6vOQ