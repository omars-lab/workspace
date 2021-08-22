#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh

function update_shorcuts() {

  TODAY=$(date +'>%Y-%m-%d')
  YESTERDAY=$(date -r $(expr $(date '+%s') - 86400 ) +'>%Y-%m-%d')
  TOMORROW=$(date -v +1d +'>%Y-%m-%d')
  WEEKEND=">$(${DIR}/dateround.py ${TODAY} 'Saturday')"
  SAT=">$(${DIR}/dateround.py ${TODAY} 'Saturday')"
  SUN=">$(${DIR}/dateround.py ${TODAY} 'Sunday')"
  MON=">$(${DIR}/dateround.py ${TODAY} 'Monday')"
  TUE=">$(${DIR}/dateround.py ${TODAY} 'Tuesday')"
  WED=">$(${DIR}/dateround.py ${TODAY} 'Wednesday')"
  THU=">$(${DIR}/dateround.py ${TODAY} 'Thursday')"
  FRI=">$(${DIR}/dateround.py ${TODAY} 'Friday')"

  ${DIR}/clean-shortcuts.sh "today"
  ${DIR}/clean-shortcuts.sh "td"
  ${DIR}/clean-shortcuts.sh "yesterday"
  ${DIR}/clean-shortcuts.sh "yd"
  ${DIR}/clean-shortcuts.sh "tomorrow"
  ${DIR}/clean-shortcuts.sh "tm"
  ${DIR}/clean-shortcuts.sh "weekend"
  ${DIR}/clean-shortcuts.sh "wknd"
  
  ${DIR}/clean-shortcuts.sh "[0-9]d"
  ${DIR}/clean-shortcuts.sh "[0-9]w"
  ${DIR}/clean-shortcuts.sh "[0-9]m"

  sleep 1 

  /usr/local/bin/shortcuts update '#weekend' "${WEEKEND}"
  /usr/local/bin/shortcuts update '@weekend' "${WEEKEND}"
  /usr/local/bin/shortcuts update '>weekend' "${WEEKEND}"

  /usr/local/bin/shortcuts update '#wknd' "${WEEKEND}"
  /usr/local/bin/shortcuts update '@wknd' "${WEEKEND}"
  /usr/local/bin/shortcuts update '>wknd' "${WEEKEND}"

  /usr/local/bin/shortcuts update '>sun' "${SUN}"
  /usr/local/bin/shortcuts update '>mon' "${MON}"
  /usr/local/bin/shortcuts update '>tue' "${TUE}"
  /usr/local/bin/shortcuts update '>wed' "${WED}"
  /usr/local/bin/shortcuts update '>thu' "${THU}"
  /usr/local/bin/shortcuts update '>fri' "${FRI}"
  /usr/local/bin/shortcuts update '>sat' "${SAT}"

  /usr/local/bin/shortcuts update '#yesterday' "${YESTERDAY}"
  /usr/local/bin/shortcuts update '@yesterday' "${YESTERDAY}"
  /usr/local/bin/shortcuts update '>yesterday' "${YESTERDAY}"

  /usr/local/bin/shortcuts update '#yd' "${YESTERDAY}"
  /usr/local/bin/shortcuts update '@yd' "${YESTERDAY}"
  /usr/local/bin/shortcuts update '>yd' "${YESTERDAY}"

  /usr/local/bin/shortcuts update '#today' "${TODAY}"
  /usr/local/bin/shortcuts update '@today' "${TODAY}"
  /usr/local/bin/shortcuts update '>today' "${TODAY}"

  /usr/local/bin/shortcuts update '#td' "${TODAY}"
  /usr/local/bin/shortcuts update '@td' "${TODAY}"
  /usr/local/bin/shortcuts update '>td' "${TODAY}"

  /usr/local/bin/shortcuts update '#tomorrow' "${TOMORROW}"
  /usr/local/bin/shortcuts update '@tomorrow' "${TOMORROW}"
  /usr/local/bin/shortcuts update '>tomorrow' "${TOMORROW}"

  /usr/local/bin/shortcuts update '#tm' "${TOMORROW}"
  /usr/local/bin/shortcuts update '@tm' "${TOMORROW}"
  /usr/local/bin/shortcuts update '>tm' "${TOMORROW}"

  /usr/local/bin/shortcuts update '<1d' "$(date -v -1d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<2d' "$(date -v -2d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<3d' "$(date -v -3d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<4d' "$(date -v -4d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<5d' "$(date -v -5d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<6d' "$(date -v -6d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<7d' "$(date -v -7d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<1w' "$(date -v -7d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<2w' "$(date -v -14d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<3w' "$(date -v -21d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<4w' "$(date -v -28d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  /usr/local/bin/shortcuts update '<1m' "$(date -v -1m +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"

  /usr/local/bin/shortcuts update '>1d' "$(date -v +1d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>2d' "$(date -v +2d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>3d' "$(date -v +3d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>4d' "$(date -v +4d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>5d' "$(date -v +5d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>6d' "$(date -v +6d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>7d' "$(date -v +7d +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>1w' "$(date -v +1w +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>2w' "$(date -v +2w +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>3w' "$(date -v +3w +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>4w' "$(date -v +4w +'>%Y-%m-%d') #usedShortcut"
  /usr/local/bin/shortcuts update '>1m' "$(date -v +1m +'>%Y-%m-%d') #usedShortcut"

}

function main() {
  echo "Initiated 1h Cron as $(whoami)"
  update_shorcuts
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"1h Cron\",\"/g" | sed 's/$/"/g'
}

main | prefix_logs >> ${LOGS_DIR}/cron.log
