#!/usr/bin/env python3

# download html file and select elements based on css

import requests
import json
from bs4 import BeautifulSoup
import sys
from http.cookiejar import CookieJar

ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'

def download_url(url):
    # https://stackoverflow.com/questions/6878418/putting-a-cookie-in-a-cookiejar
    # https://stackoverflow.com/questions/27652543/how-to-use-python-requests-to-fake-a-browser-visit-a-k-a-and-generate-user-agent
    headers = { 'User-Agent': ua }
    jar = CookieJar()
    data = requests.get(url, headers=headers, cookies=jar).content
    return data

def read_stdin():
    return sys.stdin.read()


def html_element_as_json(match):
	if not match:
		return json.dumps({})
	resp = match.attrs
	resp['text'] = (match.text.strip())
	return json.dumps(resp)


def main(url, selector):
    data = download_url(url) if not url.strip() == '-' else read_stdin()
    # print(data)
    soup = BeautifulSoup(data, features="html.parser")
    matches = soup.select(selector)
    for match in matches:
        print(html_element_as_json(match))
    sys.stderr.write(f'{len(matches)} matches')

main(sys.argv[1], sys.argv[2])


