#!/usr/bin/env python
import urllib.parse
import sys
import re
cleaned_url = re.sub("^.*http", "http", sys.stdin.read().strip()) 
parsed_url = urllib.parse.urlparse(cleaned_url)
query_params = urllib.parse.parse_qs(parsed_url.query)
print(parsed_url)
print(query_params)

# get rid of analytics stuff ...
# https://docs.python.org/3/library/urllib.parse.html
# https://salesforce.stackexchange.com/questions/302677/web-analytics-connector-parameter-string-issue
