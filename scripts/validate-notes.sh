#!/bin/bash

# Find all links in notes ...
# Ensure they point to the right places / files exist!

#  Should I have a build-notes / compile-notes script?

function find_links() {
	egrep -rino -I '[[][^[]+[]][(][^)]+[)]' ${1:-.} \
	| sed -E 's/(.*):([0-9]+):[[][^[]+[]][(]([^)]+)[)]/\1\t\2\t\3/g' 2>/dev/null \
	| jq -Rc 'split("\t") | {file:.[0], lineNumber:.[1], link:.[2]}'
}

function validate_links() {
	find_links ${1:-.} \
	| jq -r '.link' \
	| sort | uniq -c
}

validate_links ../../personalbook
