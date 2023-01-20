#!/usr/bin/env python3

# Todo ... add shortcut to run this ...

import xerox
import urllib.parse
import sys
import re

def query_param_is_for_marketing(q): 
	# Add urls to distinguish query params per site ...
	return (
		False
		or q.startswith("campaign")
		or q.startswith("target")
		or q.startswith("adgroup")
		or q.startswith("sc")
		or "clid" in q
		or q.startswith("utm_")
	)

def parse(url):
	return url.strip()

def clean_url(url):
	cleaned_url = re.sub("^.*http", "http", url) 
	parsed_url = urllib.parse.urlparse(cleaned_url)
	query_params = urllib.parse.parse_qs(parsed_url.query)
	print(parsed_url)
	print(query_params)
	cleaned_query = {
		k: v [0]
		for k, v in query_params.items()
		if not query_param_is_for_marketing(k)
	}
	print(cleaned_query)
	print(parsed_url)
	cleaned_url = urllib.parse.urlunparse(
		(parsed_url.scheme, parsed_url.netloc, parsed_url.path, parsed_url.params, urllib.parse.urlencode(cleaned_query, safe="/:", encoding='utf-8', quote_via=urllib.parse.quote), parsed_url.fragment)
	)
	# get rid of analytics stuff ...
	# https://docs.python.org/3/library/urllib.parse.html
	# https://salesforce.stackexchange.com/questions/302677/web-analytics-connector-parameter-string-issue
	return cleaned_url

def main():
    if sys.stdin.isatty():
        url = parse(xerox.paste())
    else:
        url = parse(sys.stdin.read())
    url = clean_url(url)
    xerox.copy(url)

main()

