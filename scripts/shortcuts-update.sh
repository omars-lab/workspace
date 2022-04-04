#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${DIR}/cron-common.sh
PATH="${DIR}:${PATH}"
conda activate workspace

# Insalling Shortcuts ...
# https://github.com/rodionovd/shortcuts
# arch -x86_64 brew install rodionovd/taps/shortcuts

function update_shortcut() {
  /usr/local/bin/shortcuts update $@
  sleep 0.1
}

function update_time_based_shorcuts() {
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
  DONE="$(date +'@done(%Y-%m-%d %H:%M %p)') #usedShortcut"
  BINNED_NOW=$(date +'%Y-%m-%dT%H:00:00%z')

  shortcuts-clean.sh "^[>#@][a-z]+"
  shortcuts-clean.sh "^[><][0-9][dwm]"
  shortcuts-clean.sh "hour"
  shortcuts-clean.sh "now"
  shortcuts-clean.sh "done"
  
  sleep 1 

  update_shortcut '#hour' "${BINNED_NOW}"
  update_shortcut '@hour' "${BINNED_NOW}"
  update_shortcut '>hour' "${BINNED_NOW}"

  update_shortcut '#now' "${BINNED_NOW}"
  update_shortcut '@now' "${BINNED_NOW}"
  update_shortcut '>now' "${BINNED_NOW}"

  update_shortcut '#done' "${DONE}"
  update_shortcut '>done' "${DONE}"
  
  # Results in cyclic deps with noteplan when shifting ...
  # update_shortcut '@done' "${DONE}"

  update_shortcut '#weekend' "${WEEKEND}"
  update_shortcut '@weekend' "${WEEKEND}"
  update_shortcut '>weekend' "${WEEKEND}"

  update_shortcut '#wknd' "${WEEKEND}"
  update_shortcut '@wknd' "${WEEKEND}"
  update_shortcut '>wknd' "${WEEKEND}"

  update_shortcut '>sun' "${SUN}"
  update_shortcut '>mon' "${MON}"
  update_shortcut '>tue' "${TUE}"
  update_shortcut '>wed' "${WED}"
  update_shortcut '>thu' "${THU}"
  update_shortcut '>fri' "${FRI}"
  update_shortcut '>sat' "${SAT}"

  update_shortcut '#yesterday' "${YESTERDAY}"
  update_shortcut '@yesterday' "${YESTERDAY}"
  update_shortcut '>yesterday' "${YESTERDAY}"

  update_shortcut '#today' "${TODAY}"
  update_shortcut '@today' "${TODAY}"
  update_shortcut '>today' ">today ${TODAY}"

  update_shortcut '#tomorrow' "${TOMORROW}"
  update_shortcut '@tomorrow' "${TOMORROW}"
  update_shortcut '>tomorrow' "${TOMORROW}"

  update_shortcut '#yd' "${YESTERDAY}"
  update_shortcut '@yd' "${YESTERDAY}"
  update_shortcut '>yd' "${YESTERDAY}"

  update_shortcut '#td' "${TODAY}"
  update_shortcut '@td' "${TODAY}"
  update_shortcut '>td' "${TODAY}"

  update_shortcut '#tm' "${TOMORROW}"
  update_shortcut '@tm' "${TOMORROW}"
  update_shortcut '>tm' "${TOMORROW}"

  update_shortcut '<1d' "$(date -v -1d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<2d' "$(date -v -2d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<3d' "$(date -v -3d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<4d' "$(date -v -4d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<5d' "$(date -v -5d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<6d' "$(date -v -6d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<7d' "$(date -v -7d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<1w' "$(date -v -7d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<2w' "$(date -v -14d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<3w' "$(date -v -21d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<4w' "$(date -v -28d +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"
  update_shortcut '<1m' "$(date -v -1m +'@done(%Y-%m-%d 00:00 %p)') #usedShortcut"

  update_shortcut '>1d' "$(date -v +1d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>2d' "$(date -v +2d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>3d' "$(date -v +3d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>4d' "$(date -v +4d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>5d' "$(date -v +5d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>6d' "$(date -v +6d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>7d' "$(date -v +7d +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>1w' "$(date -v +1w +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>2w' "$(date -v +2w +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>3w' "$(date -v +3w +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>4w' "$(date -v +4w +'>%Y-%m-%d') #usedShortcut"
  update_shortcut '>1m' "$(date -v +1m +'>%Y-%m-%d') #usedShortcut"

}

function update_shorcuts() {
  
  ${DIR}/shortcuts-clean.sh "^[:].*"
  sleep 1 
  # https://apple.stackexchange.com/questions/4074/what-do-i-type-to-produce-the-command-symbol-in-mac-os-x
  # https://support.apple.com/en-us/HT201236
  update_shortcut ':opt' "⌥"
  update_shortcut ':cmd' "⌘"
  update_shortcut ':ctrl' "⌃"
  update_shortcut ':shift' "⇧"
}

function prefix_logs() {
  NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
  sed "s/^/${NOW},\"Shorcuts Script\",\"/g" | sed 's/$/"/g'
}

function main() {
  update_time_based_shorcuts | prefix_logs
  update_shorcuts | prefix_logs
}

${1:main}
