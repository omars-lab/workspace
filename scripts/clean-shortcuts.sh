#!/bin/bash 

function format_shortcuts() {
  sed -E -e 's/^[0-9]+: //g' -e 's/ —>.*//g' \
  | grep -E '^"[>@#]' \
  | grep -v zoom \
  | sed 's/"//g'
}

function stat_shortcuts() {
  /usr/local/bin/shortcuts read \
  | format_shortcuts \
  | sort | uniq -c
}

function list_unique_shortcuts() {
  stat_shortcuts \
  | awk '{print $2}' \
  | grep "${1}"
}

function delete_shortcuts() {
  /usr/local/bin/shortcuts read \
  | format_shortcuts \
  | grep -E "${1}" \
  | xargs -n 1 /usr/local/bin/shortcuts delete "${1}"
}


for shortcut in $(list_unique_shortcuts "${1}")
do
  delete_shortcuts "${shortcut}"
done  
stat_shortcuts
