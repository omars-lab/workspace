import requests
from bs4 import BeautifulSoup
import sys
data = requests.get(sys.argv[1]).content
soup = BeautifulSoup(data, features="html.parser")
# https://www.crummy.com/software/BeautifulSoup/bs4/doc/
print(f"- [ ] [{soup.title.string}]({sys.argv[1]})")
