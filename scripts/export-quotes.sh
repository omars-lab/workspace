#!/bin/bash

DIR=/Users/omareid/Workspace/git/personalbook/roles/The\ Motivator/Capturing\ Mental\ Journey

grep -rih '^- [a-zA-Z].*' "${DIR}" \
	| sed 's/ [@><][0-9]{4}-[0-9]{2}-[0-9]{2}//g' \
	| grep -v '[#]ignore' \
	| tr '[:lower:]' '[:upper:]'
