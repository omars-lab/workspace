#!/bin/zsh

# https://serverfault.com/questions/59262/bash-print-stderr-in-red-color
function color-red-bash() {
  while read line; 
  do 
    echo -e "\e[01;31m$line\e[0m" ; 
  done
}

function color-red-zsh() {
  while read line; 
  do 
    print -P "%F{red}$line%f"
  done
}


(echo "Role with Most Files ..." | color-red-zsh )>&2
# find . -type d -maxdepth 1 -exec bash -c '{ find "${0}" -type f | wc -l | sed -E "s/^[ ]+//g" | tr -d "\n" ; echo "${0}" ; } ' "{}" \;
find roles* -type f  | egrep -o '^[^/]+/[^/]+' | sort | uniq -c | sort
