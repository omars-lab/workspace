# Generating seqeunces of things ..
function hours() {
	seq -f "%02g" 0 23
}

function padded-seq() {
	PADDING=${1}
	shift
	seq ${@} | xargs -n 1 printf "%0${PADDING}d\n"
}

function stream-days() {
	CURRENT_YEAR=$(date +"%Y")
	CURRENT_MONTH=$(date +"%m")
	DAYS_IN_CURRENT_MONTH=$(date -j -f '%Y-%m-%d' "${CURRENT_YEAR}-${CURRENT_MONTH}-0" +"%d")
	MAX=${1:-${DAYS_IN_CURRENT_MONTH}}
	padded-seq 2 1 ${MAX}
}

