#!/bin/bash

# """
# Only create a quote for lines that start with - ... 
# 	No sub quotes ...
# 	No - [ ] ...
# """

DIR=/Users/omareid/Workspace/git/personalbook/roles/The\ Motivator/Capturing\ Mental\ Journey

# Step 1 ... add ids ...
# For valid lines that don't have an id ... get the next id ...
# ./increment-and-get-counter.sh motivational-quotes

for F in $(find "${DIR}" -type f -name '*.md' -exec bash -c 'echo "${0}" | base64' "{}" \;)
do 
	F=$(echo "${F}" | base64 -D)
	echo "---------------- START ${F} -------------------"
	gsed -E '/(#id:[0-9]+|[#]ignore)/!s/^- ([a-zA-Z].*)/echo "-" "\1" "#id:motivational-quote-"$(increment-and-get-counter.sh motivational-quotes)/ge' "${F}"
	# gsed -E '/(#id:[0-9]+|[#]ignore)/!s/^- ([a-zA-Z].*)/echo "-" "\1" "#id:motivational-quote-"$(increment-and-get-counter.sh motivational-quotes) "#hash:"$(hash.py "\1")/ge' "${F}"
	echo 
	echo "---------------- END ${F} -------------------"
done 

# Step 2 ... get lines to save ...
# grep -rih '^- [a-zA-Z].*' "${DIR}" \
# 	| sed 's/ [@><][0-9]{4}-[0-9]{2}-[0-9]{2}//g' \
# 	| grep -v '[#]ignore' \
# 	| tr '[:lower:]' '[:upper:]'

# ------------------------------------------
# Experimenting with sed execution ... powerful!
# https://stackoverflow.com/questions/6684857/how-to-skip-lines-matching-a-string
# https://stackoverflow.com/questions/14348432/how-to-find-replace-and-increment-a-matched-number-with-sed-awk
# echo 123 | gsed -E 's/([0-9]+)/expr "\1" "*" "2"/ge'
# echo 123 | gsed -E 's/([0-9]+)/expr "\1" "*" "2"/ge'
# echo 123 | gsed -E 's/([0-9]+)/increment-and-get-counter.sh motivational-quotes/ge'
# echo 123 | gsed -E 's/([0-9]+)/echo "\1" $(increment-and-get-counter.sh motivational-quotes)/ge'

