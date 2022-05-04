import urllib.parse
import sys
import os.path 
import json

import os

# Add the notion of a resolver ... that has different resolving algorithms ..

URL = str(sys.argv[1])

parsed_url = urllib.parse.urlparse(URL)
# >>> ParseResult(scheme='glue', netloc='test', path='', params='', query='', fragment='')

assert str(parsed_url.scheme.lower()) == "glue", "only glue URLs are supported"

def choose_file(url):
	if url.netloc == "initiatives":
		return "/Applications/Glue.app/Contents/Resources/Scripts/glue.initiatives.json"
	if url.netloc == "habits":
		return "/Applications/Glue.app/Contents/Resources/Scripts/glue.habits.json"
	return os.path.expanduser("~/.glue.json")

def open_url(argv, url):
    # os.system(f"""
    #     open "{url}";
    # """)
    # echo "[{argv}]" > /tmp/glue.txt ;
    # echo "{url}" > /tmp/glue.url
    pass

with open(choose_file(parsed_url)) as fh:
    mapping = json.load(fh)

mapped_url = mapping.get(parsed_url.path[1:])

# https://github.com/shengyou/vscode-handler

if mapped_url is None:
    # https://code-maven.com/display-notification-from-the-mac-command-line
    # https://www.pythongasm.com/desktop-notifications-with-python/
    title = "Glue Got Stuck"
    message = f"No mapping found for: {URL}"
    command = f'''
    osascript -e 'display notification "{message}" with title "{title}"'
    '''
    os.system(command)
    print("https://www.disney.com/404")
else:
    # https://www.urlencoder.io/python/
    # print(urllib.parse.quote(mapped_url, safe=''))
    open_url(sys.argv, mapped_url)
    print(mapped_url)
