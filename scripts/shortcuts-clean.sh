#!/bin/bash 

function format_shortcuts() {
  # | grep -E '^"[>@#]' \
  # | grep -v zoom \
  sed -E -e 's/^[0-9]+: //g' -e 's/ —>.*//g' \
  | sed 's/"//g'
}

function stat_shortcuts() {
  /usr/local/bin/shortcuts read \
  | format_shortcuts \
  | sort \
  | uniq -c
}

function list_unique_shortcuts() {
  stat_shortcuts \
  | awk '{print $2}' \
  | grep -E "${1}"
}

function delete_shortcuts() {
  /usr/local/bin/shortcuts read \
  | format_shortcuts \
  | grep -E "${1}" \
  | xargs -n 1 /usr/local/bin/shortcuts delete "${1}"
}


for shortcut in $(list_unique_shortcuts "${1}")
do
  echo "Deleting shortcut: ${shortcut}" >&2
  delete_shortcuts "${shortcut}"
  sleep 0.1
done  
stat_shortcuts
