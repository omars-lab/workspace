#!/bin/bash

for d in $(ls -1 ${DIRS_GIT})
do
  eval "alias cd-${d}='cd ${DIRS_GIT}/${d}'"
done 
