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

source_if_exists /usr/local/bin/miniconda3/etc/profile.d/conda.sh \
	|| source_if_exists ${HOME}/opt/anaconda3/etc/profile.d/conda.sh

export SERIAL_NUMBER=$(get_serial_number)
