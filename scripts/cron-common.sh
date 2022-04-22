# This file gets sourced ... therefore ... I dont declare the variable of the root dir ....
# https://medium.com/better-programming/https-medium-com-ratik96-scheduling-jobs-with-crontab-on-macos-add5a8b26c30
# - [Dealing with Command Not Found](https://ole.michelsen.dk/blog/schedule-jobs-with-crontab-on-mac-osx/)
eval "$(/usr/local/Homebrew/bin/brew shellenv)"
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

LOGS_DIR=${HOME}/.logs
mkdir -p ${LOGS_DIR}

function get_serial_number() {
	( system_profiler SPHardwareDataType | grep Serial ) 2>/dev/null | sed 's/[^:]*: //g'
}

function source_if_exists() {
	FILE_TO_SOURCE="${1}"
	if [[ -f "${FILE_TO_SOURCE}" ]]
	then	
		# echo Sourcing "${FILE_TO_SOURCE}" >&2
		source "${FILE_TO_SOURCE}"
	else
		false
	fi
}

function prefix_logs() {
	CRON_IDENTIFIER="${1:?Arg1=Identifier for CRON Job.}"
	NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")
	sed "s/^/${NOW},\"${CRON_IDENTIFIER} Cron\",\"/g" | sed 's/$/"/g'
}

function log.error() {
	( echo "$@" | prefix_logs "ERROR" ) >> ${LOGS_DIR}/cron.error.log 
}

function log.debug() {
	( echo "$@" | prefix_logs "DEBUG" ) >> ${LOGS_DIR}/cron.log 
}

function run_cron_job() {
	CRON_IDENTIFIER="${1:?Arg1=Identifier for CRON Job.}"
	STDOUT_LOG=$(mktemp)
	STDERR_LOG=$(mktemp)
	main \
		1>"${STDOUT_LOG}" \
		2>"${STDERR_LOG}"
	( cat "${STDOUT_LOG}" | prefix_logs "${CRON_IDENTIFIER}" ) >> ${LOGS_DIR}/cron.log 
	( cat "${STDERR_LOG}" | prefix_logs "${CRON_IDENTIFIER}" ) >> ${LOGS_DIR}/cron.error.log
	rm "${STDOUT_LOG}" "${STDERR_LOG}"
	# ( main | prefix_logs ) 2>>${LOGS_DIR}/cron.error.log 1>>${LOGS_DIR}/cron.log
}

source_if_exists /usr/local/bin/miniconda3/etc/profile.d/conda.sh \
	|| source_if_exists ${HOME}/opt/anaconda3/etc/profile.d/conda.sh

export SERIAL_NUMBER=$(get_serial_number)

function play_click() {
	# https://superuser.com/questions/598783/play-sound-on-mac-terminal
	# echo -e "\a"
	afplay /Applications/Flic.app/Contents/Resources/trigger_click.mp3 &
}
