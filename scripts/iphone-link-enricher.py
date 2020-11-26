# check if an item is in stock in costco

import requests
from bs4 import BeautifulSoup
import sys

import xerox
from uncurl.api import parse_context as parse


def get_title_for_link(link):
    data = requests.get(link).content
    soup = BeautifulSoup(data, features="html.parser")
    return soup.title.contents[0].strip()

def main():
    if sys.stdin.isatty():
        result = parse(xerox.paste())
    else:
        result = parse(sys.stdin.read())
    items = check_if_item_in_stock(sys.argv[1], sys.argv[2], result)
    if len(items) < 1:
        print("Item not found")
    else:
        out_of_stock = "OUT OF STOCK" if len(items[0].findAll("img", {"alt":"Out of Stock"})) > 0 else "IN STOCK"
        description = (items[0].findAll("p", {"class":"description"})[0].a.contents[0])
        print(f"{out_of_stock}: {description}")

def enrich_line(l):
    if (not l) or (not l.strip()): 
        # print(f"e1: [{l}]")
        return l
    if (not l.startswith("- http://")) and(not l.startswith("- https://")):
        # print(f"e2: [{l}]")
        return l
    link = l.split(" ", 2)[1].strip()
    title = get_title_for_link(link)
    return l.replace(link, f"[{title}]({link})")

def main():
    with open("/Users/omareid/Dropbox/Apps/iA Writer/unorganized, iphone.txt") as fh:
        lines = fh.readlines()
    for line in lines:
        print(enrich_line(line).strip())

main()

# Treat the following as bad url ...
# 403 Forbidden
# Sorry! Something went wrong!
