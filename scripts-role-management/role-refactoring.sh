#!/bin/bash

# How can I see how many times I have moved a file around / renamed it? ... to get an idea of how unsure I am about placing a activity / refactoring it?
# https://kgrz.io/use-git-log-follow-for-file-history.html

FILE=$(mktemp)
find roles/The\ Learner -type f -exec ./activity-history.sh "{}" "${FILE}" \; 
# cat "${FILE}"
#  cat "${FILE}" | sed 's/--NEWLINE--//g'
#  rm ${FILE}

