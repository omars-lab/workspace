#!/bin/bash

function expand_refs_in_dir() (
	DIR="${1}"
	cd "${DIR}"
	TODAY=$(date +'>%Y-%m-%d')
	# For file that contain the today string ... expand lines that haven't already been expanded
	grep -ril '>today' . \
		| xargs -t -I __ gsed -E -i "/.*([*-] [[][xX-][]]|${TODAY}).*/! s/ >today/ >today ${TODAY}/" "__"
)

expand_refs_in_dir "${HOME}/Library/Mobile Documents/iCloud~co~noteplan~NotePlan/Documents/Notes"
