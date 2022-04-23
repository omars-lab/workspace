function secret() {
	PASSWORD="${1}"
	/usr/bin/security find-generic-password -l ${PASSWORD} 2>/dev/null >/dev/null || echo "Not found: ${PASSWORD}" >&2
	bash -c "/usr/bin/sudo /usr/bin/security find-generic-password -l ${PASSWORD} -w | tr -d '\n' | pbcopy"
}
