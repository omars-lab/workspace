#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# - [x] Add ability to check every minute and enrich line on csv file ..
# - [x] Add ability to get notification for when magic mountain opens for the very first time at the begining of a day

NOW=$(date +"%Y-%m-%dT%H:%M:%SZ")
FROM=$(date +"%Y-%m-%d")
TO=$(date -r $(expr $(date '+%s') + \( 86400 \* 30 \) ) +"%Y-%m-%d")

MK_FILE=${HOME}/Dropbox/Automation/disney-world-magic-kingdom-openings.csv
TMP_FILE=$(mktemp)

curl -s "https://disneyworld.disney.go.com/availability-calendar/api/calendar?segment=tickets&startDate=${FROM}&endDate=${TO}" \
  -H 'authority: disneyworld.disney.go.com' \
  -H 'referer: https://disneyworld.disney.go.com/availability-calendar/' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-US,en;q=0.9,id;q=0.8' \
  -H 'content-type: application/json' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_2_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.128 Safari/537.36' \
  -H 'dnt: 1' \
  -H 'sec-ch-ua: "Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  > ${TMP_FILE}
  
jq -r -f ${DIR}/check-disneyworld.jq ${TMP_FILE} \
  | grep -e 'Magic Kingdom' \
  | sed "s/^/${NOW},/g" \
  >> ${MK_FILE}

jq -r -f ${DIR}/check-disneyworld.jq ${TMP_FILE} \
  | grep -e 'Magic Kingdom' \
  | grep -E -e '2021-06-(0[789]|10)' \
  && ${DIR}/notify-iphone.sh "Magic Moutain Has Openings" "1M Cron"

( grep "${FROM}" ${MK_FILE} | wc -l | xargs -n 1 test 1 -eq ) \
	&& ${DIR}/notify-iphone.sh "Magic Moutain Just Opened for ${FROM}" "1M Cron"

rm ${TMP_FILE}
