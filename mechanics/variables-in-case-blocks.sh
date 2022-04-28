#!/bin/bash

function classic-variable(){
	VARIABLE=123
	case ${1:-123} in
		${VARIABLE})
			echo matched variable
			true
		;;
		*)
			false
		;;
	esac
}

function regex-variable-v1(){
	VARIABLE='(123)|(345)'
	ARG=${1:-345}
	case ${ARG} in
		${VARIABLE})
			echo matched variable
			true
		;;
		*)
			false
		;;
	esac
}

function regex-variable-v2(){
	# https://stackoverflow.com/questions/9631335/regular-expressions-in-a-bash-case-statement
	# https://askubuntu.com/questions/678915/whats-the-difference-between-and-in-bash
	VARIABLE='(123)|(345)'
	ARG=${1:-345}
	case ${ARG} in
		$(egrep -o "${VARIABLE}" <<< "${ARG}"))
			echo matched variable
			true
		;;
		*)
			false
		;;
	esac
}

classic-variable
echo '---'
regex-variable-v1  # did not work ...
echo '---'
regex-variable-v2

# Result: ...

#>>> matched variable
#>>> ---
#>>> ---
#>>> matched variable
