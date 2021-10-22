#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/functions.sh

# https://rimuhosting.com/knowledgebase/linux/misc/trapping-ctrl-c-in-bash
# trap ctrl-c and call pause_audio_players() 
trap pause_audio_players INT

NOW=$(date +"%I:%M%p")
echo "Playing audio files configured for ... ${NOW}"
case "${NOW}" in
  08:30AM)
	scan_players \
		| xargs -n 1 bash -c 'source ${0}/functions.sh; AUDIO_LEVEL=15 play_audio_from_url "${1}" "${2}"' "${DIR}" "${SURAT_ALBAQARAH}"
  ;;
esac

# downloading athan
# youtube-dl -x --audio-format mp3 https://www.youtube.com/watch\?v\=iaWZ_3D6vOQ
