#!//usr/bin/env python

# Encirch Links added through iphone shortcut ...

import glob
import os
import requests
from bs4 import BeautifulSoup
import sys


def get_title_for_link(link):
    data = requests.get(link).content
    soup = BeautifulSoup(data, features="html.parser")
    return soup.title.contents[0].strip() if (soup.title and soup.title.contents) else None


def enrich_line(l):
    if (not l) or (not l.strip()): 
        # print(f"e1: [{l}]")
        return l
    if (not l.startswith("- http://")) and(not l.startswith("- https://")):
        # print(f"e2: [{l}]")
        return l
    link = l.split(" ", 2)[1].strip()
    title = get_title_for_link(link)
    title = default_bad_titles(title)
    return l.replace(link, f"[{title}]({link})")


def default_bad_titles(title):
    # Treat the following as bad url ...
    # 403 Forbidden
    # Sorry! Something went wrong!
    title = "" if title is None else title
    if title.strip() in ["403 Forbidden", "Sorry! Something went wrong!", ""]:
        return "TODO"
    return title
    

def main():
    filepath = glob.glob(os.path.expanduser("~/Dropbox*/Apps/iA Writer/unorganized, iphone.txt"))[0]
    with open(filepath) as fh:
        lines = fh.readlines()
    for line in lines:
        print(enrich_line(line).strip())

main()


