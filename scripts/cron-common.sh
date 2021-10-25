# https://medium.com/better-programming/https-medium-com-ratik96-scheduling-jobs-with-crontab-on-macos-add5a8b26c30

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

LOGS_DIR=${HOME}/.logs
mkdir -p ${LOGS_DIR}

SERIAL_NUMBER=$( \
	( system_profiler SPHardwareDataType | grep Serial ) 2>/dev/null | sed 's/[^:]*: //g' \
)

# - [Dealing with Command Not Found](https://ole.michelsen.dk/blog/schedule-jobs-with-crontab-on-mac-osx/)
eval "$(/usr/local/Homebrew/bin/brew shellenv)"
PATH=${DIR}:/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

function source_if_exists() {
	FILE_TO_SOURCE="${1}"
	if [[ -f "${FILE_TO_SOURCE}" ]]
	then	
		echo Sourcing "${FILE_TO_SOURCE}"
		source "${FILE_TO_SOURCE}"
	else
		false
	fi
}

source_if_exists /usr/local/bin/miniconda3/etc/profile.d/conda.sh \
	|| source_if_exists ${HOME}/opt/anaconda3/etc/profile.d/conda.sh

conda activate workspace
