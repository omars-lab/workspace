#!/usr/bin/env python3

import sys
import markdown
from bs4 import BeautifulSoup

with open(sys.argv[1]) as fh:
    body_markdown = fh.read()

soup = BeautifulSoup(markdown.markdown(body_markdown), features="html.parser")
#           https://www.crummy.com/software/BeautifulSoup/bs4/doc/#css-selectors
for link in soup.select("li a"):
    print(link.attrs["href"])

# from lxml import etree
# doc = etree.fromstring(markdown.markdown(body_markdown))
# for link in doc.xpath('//a'):
#   print(link.get('href')))