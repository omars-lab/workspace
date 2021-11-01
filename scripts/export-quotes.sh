#!/bin/bash

# """
# Only create a quote for lines that start with - ... 
# 	No sub quotes ...
# 	No - [ ] ...
# """
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
QUOTE_DIR=/Users/omareid/Workspace/git/personalbook/roles/The\ Motivator/Capturing\ Mental\ Journey

function append_ids_to_quotes_without_ids() {
	# For valid lines that don't have an id ... get the next id ... using `./increment-and-get-counter.sh motivational-quotes`
	BACKUP_EXTENSION=$(date +"%Y-%m-%dT%H:%M:%SZ.backup")
	for F in $(find "${1}" -type f -name '*.md' -exec bash -c 'echo "${0}" | base64' "{}" \;)
	do 
		F=$(echo "${F}" | base64 -D)
		echo "Processing: ${F}"
		gsed \
			-E \
			-i"${BACKUP_EXTENSION}" \
			'/(#id:motivational-quote-[0-9]+|[#]ignore)/!s/^- ([a-zA-Z].*)/echo "-" "\1" "#id:motivational-quote-"$(increment-and-get-counter.sh motivational-quotes)/ge' "${F}"
			# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			# Ignore lines with the following ...
			#                                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			#                                                             Execute a shell script with the first captured arg 

			# gsed -E '/(#id:[0-9]+|[#]ignore)/!s/^- ([a-zA-Z].*)/echo "-" "\1" "#id:motivational-quote-"$(increment-and-get-counter.sh motivational-quotes) "#hash:"$(hash.py "\1")/ge' "${F}"
			# Decided not to add hash ... the quote can change ... add hash when computing / exporting to ddb ...
	done 
}

function find_quotes() {
	# find quotes at begining of line ... that are not todos ...
	grep --exclude '*.backup' -rih '^- [a-zA-Z].*[#]id:motivational-quote.*' "${1}"
}

function clean_quotes() {
	# remove dates from quotes ... 
	sed 's/ [@><][0-9]{4}-[0-9]{2}-[0-9]{2}//g'
}

function ignore_quotes() {
	# ignore quotes that have been explicitly marked to be ignored 
	grep -v '[#]ignore'
}

function uppercase_quotes() {
	# turn things upper case ...
	tr '[:lower:]' '[:upper:]'
}

function structure_quotes() {
	sed -E 's/- (.*) ?#id:motivational-quote-([0-9]+) ?(.*) ?/{"id":\2,"quote":"\1\3"}/Ig'
}

function sort_quotes() {
	# tee /dev/tty | \
	jq -s -c 'sort_by(.id) | .[]'
}

function get_motivational_quotes() {
	find_quotes "${1}" \
		| clean_quotes \
		| ignore_quotes \
		| uppercase_quotes \
		| structure_quotes \
		| sort_quotes \
		| prepare_for_dynamodb_upload "${2}" "${3}"
}

function prepare_for_dynamodb_upload() {
	TABLE_NAME=${1}
	# Recursively prepare items for upload into a particular table ..
	python -u ${DIR}/prepare-ndjson-for-dynamodb.py --table "${TABLE_NAME}" --prefix "${2}"
	# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SampleData.LoadData.html
}

function write_files_to_ddb() (
	xargs -I {} aws --no-paginate dynamodb batch-write-item --request-items "file://{}"
)

# Step 1 ... add ids to motivational quotes ...
append_ids_to_quotes_without_ids "${QUOTE_DIR}"

# Step 2 ... get lines to save ...
OUTPUT_FILE=$(mktemp)
OUTPUT_FILE_BASENAME=$(basename "${OUTPUT_FILE}")
OUTPUT_FILE_DIR=$(dirname "${OUTPUT_FILE}")

TABLE_NAME=$(aws --no-paginate dynamodb list-tables | jq -r '.TableNames|.[]' | grep MotivationalQuotes | head -n 1)
get_motivational_quotes "${QUOTE_DIR}" "${TABLE_NAME}" "${OUTPUT_FILE}" \
	| write_files_to_ddb
cat "${OUTPUT_FILE}"*
rm "${OUTPUT_FILE}"*

# ------------------------------------------
# Experimenting with sed execution ... powerful!
# https://stackoverflow.com/questions/6684857/how-to-skip-lines-matching-a-string
# https://stackoverflow.com/questions/14348432/how-to-find-replace-and-increment-a-matched-number-with-sed-awk
# echo 123 | gsed -E 's/([0-9]+)/expr "\1" "*" "2"/ge'
# echo 123 | gsed -E 's/([0-9]+)/expr "\1" "*" "2"/ge'
# echo 123 | gsed -E 's/([0-9]+)/increment-and-get-counter.sh motivational-quotes/ge'
# echo 123 | gsed -E 's/([0-9]+)/echo "\1" $(increment-and-get-counter.sh motivational-quotes)/ge'