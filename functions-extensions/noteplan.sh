
CALENDAR_DIR=~/.noteplan/Calendar
export FZF_DEFAULT_COMMAND='ls -1t'

alias tt='todo today'
alias vscode-todo="vscode ${CALENDAR_DIR}"

function todo() {
	TODAY_FILE=$(date '+%Y%m%d.txt')
	cd ${CALENDAR_DIR}
	touch ${TODAY_FILE}
	INPUT=${1:-$( fzf +s --preview "head {}" --height 75% )}
	case ${INPUT}
	in
		today)
			todo ${TODAY_FILE}
		;;
		backlog)
			todo ../Notes/backlog.txt
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

function noteplan-header() {
	# Used to append quick vscode links to a noteplan note file so it injects links into each day ...
	stream-days \
		| xargs -I {} \
			printf '* [x] Edit In [Visual Studio Code](vscode://file%s/%s.txt) >%s \n' \
				"${CALENDAR_DIR}" "$(date +'%Y%m{}')" "$(date +'%Y-%m-{}')"
}

function noteplan-shortcuts() {
    find ~/.noteplan/Notes -name .DS_Store -prune -o -type f -exec bash -c 'head -n 1 "${0}"' "{}" \; | gsed -E 's/#\s+/[[/' | gsed -E 's/\s*$/]]/g' | sort 
}
