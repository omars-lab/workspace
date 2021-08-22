function counter++() {
	date -u +"%Y-%m-%dT%H:%M:%SZ,${2:-1}" >> ${HOME}/Dropbox/counters/${1?Counter Required}
}

function counter--() {
	date -u +"%Y-%m-%dT%H:%M:%SZ,-${2:-1}" >> ${HOME}/Dropbox/counters/${1?Counter Required}
}
