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

if [[ -f /usr/local/bin/miniconda3/etc/profile.d/conda.sh ]]
then
	source /usr/local/bin/miniconda3/etc/profile.d/conda.sh
fi

if [[ -f /usr/local/bin/miniconda3/etc/profile.d/conda.sh ]]
then
	source /usr/local/bin/miniconda3/etc/profile.d/conda.sh
fi

conda activate py3
