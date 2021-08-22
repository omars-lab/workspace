#!/bin/bash

# https://github.com/ytdl-org/youtube-dl/blob/master/README.md#format-selection

function download_worst_videos() {
  youtube-dl -F "${1}" \
    | grep -v "video only" | grep -v "audio only" | grep mp4 | cut -f 1 -d ' ' | head -n 1 \
    | xargs -I __ youtube-dl -f __ "${1}"

}

for OUTPUT in $(parse-md-links.py "${1}")
do
	download_worst_videos "${OUTPUT}"
done
