function counter++() {
	date -u +"%Y-%m-%dT%H:%M:%SZ,${2:-1}" >> /Users/oeid/Dropbox/counters/${1?Counter Required}
}

function counter--() {
	date -u +"%Y-%m-%dT%H:%M:%SZ,-${2:-1}" >> /Users/oeid/Dropbox/counters/${1?Counter Required}
}