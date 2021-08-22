#!/bin/bash

function increment_and_prefix_latest_date_in_line() {
	# Find largest date in line ...
	local LINE="$(mktemp)"
	cat > ${LINE}
	LARGEST_DATE=$(\
		egrep -o '[@>][0-9]{4}-[0-9]{2}-[0-9]{2}' "${LINE}" \
			| sort -r | uniq | head -n 1 | sed 's/@/>/'\
	)
	DAY_AFTER_LARGEST_DATE=$(date -v +1d -jf '>%Y-%m-%d' +'>%Y-%m-%d' "${LARGEST_DATE}")
	# echo "${LARGEST_DATE}" "${DAY_AFTER_LARGEST_DATE}"
	# Insert new date before occurance of first date
	# https://stackoverflow.com/questions/148451/how-to-use-sed-to-replace-only-the-first-occurrence-in-a-file
	# https://stackoverflow.com/questions/4775548/how-to-pass-the-value-of-a-variable-to-the-stdin-of-a-command
	sed -E "s/([>@][0-9]{4}-[0-9]{2}-[0-9]{2})/${DAY_AFTER_LARGEST_DATE} \1/" "${LINE}"
	rm ${LINE}
}
export -f increment_and_prefix_latest_date_in_line

# Iterate through lines of a file, getting each line over stdin (intended for small files)

## Old Way: This has issues if the lines have quotes in them ...
## cat | xargs -t -L 1 bash -c ' increment_and_prefix_latest_date_in_line <<< "${@}" ' _

## New Way, Based on: https://unix.stackexchange.com/questions/7011/how-to-loop-over-the-lines-of-a-file


INPUT=$(mktemp)
cat > "${INPUT}"

N=$(cat "${INPUT}" | wc -l)
for (( i=1; i<=N; i++ )); do
    # echo $i
    sed "${i}q;d" "${INPUT}" | increment_and_prefix_latest_date_in_line
done
rm ${INPUT}
