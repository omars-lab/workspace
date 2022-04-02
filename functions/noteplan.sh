export FZF_DEFAULT_COMMAND='ls -1t'

function todo() {
	TODAY_FILE=$(date '+%Y%m%d.txt')
	# cd ~/Documents/calendar
	cd ~/Library/Mobile\ Documents/iCloud\~co\~noteplan\~NotePlan/Documents/Calendar
	touch ${TODAY_FILE}
	INPUT=${1:-$( fzf +s --preview "head {}" --height 75% )}
	case ${INPUT}
	in
		today)
			todo ${TODAY_FILE}
		;;
		backlog)
			todo backlog.txt
		;;
		*)
			vim "${INPUT}"
		;;
	esac
}

function report_todo() {
	# todo ... add logic in here to color code / add right numbers to days ... or may a shell script to do this!
	cal -h | sed -E 's/^/\t/g' | sed -E -e 's/([^0-9][0-9]{1,2})/\t\1[𐄙₃|⨯₂₇]/g' -e 's/ ?([A-Za-z]+)/\t\1\t/g' | GREP_COLOR='1;35' grep -E --color=always '(\b3\b)|$'
}