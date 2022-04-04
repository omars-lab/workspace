#!/usr/bin/env python3

# check if an item is in stock in costco

import requests
from bs4 import BeautifulSoup
import sys

import xerox
from uncurl.api import parse_context as parse


def check_if_item_in_stock(catalog_keyword, item_id, context):
    data = requests.get(
            url_to_search_costco_catalog(catalog_keyword), 
            cookies=context.cookies, 
            headers=context.headers
    ).content
    soup = BeautifulSoup(data, features="html.parser")
    divs = soup.findAll("div", {"class": "thumbnail", "itemid": item_id})
    return divs

def url_to_search_costco_catalog(catalog_keyword):
    return f"https://www.costco.com/CatalogSearch?dept=All&keyword={catalog_keyword}"

# def check_if_clorox_in_stock(context):
#     return check_if_item_in_stock("clorox", "100534416", context)

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

main()
