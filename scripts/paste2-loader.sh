#!/bin/bash

function get_other_user(){
  users | sed -e "s/$(whoami)//g" -e 's/ *//g'
}

find /Users/Shared/$(get_other_user)/clipboard -type f -exec bash -c 'cat ${0} | pbcopy; rm ${0}' '{}' \;
