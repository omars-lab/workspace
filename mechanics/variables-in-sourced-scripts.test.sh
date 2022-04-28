#!/bin/bash

function test-with-variable-v1() (
	VARIABLE=set source variables-in-sourced-scripts.sh
	echo ${VARIABLE}
	abc
)

function test-with-variable-v2() (
	export VARIABLE=set
	source variables-in-sourced-scripts.sh
	echo ${VARIABLE}
	abc
)

function test-without-variable() (
	source variables-in-sourced-scripts.sh
	abc
)

test-with-variable-v1
echo '-----'
test-with-variable-v2
# result: `matched variable` ... so they do work!
echo '-----'
test-without-variable

# Result ...

#>>> matched variable in script being sourced
#>>> 
#>>> abc
#>>> -----
#>>> matched variable in script being sourced
#>>> set
#>>> abc
#>>> -----
#>>> ./variables-in-sourced-scripts.test.sh: line 18: abc: command not found
