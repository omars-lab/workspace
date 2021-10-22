import urllib.parse
import sys
import os.path 
import json

import os

# Add the notion of a resolver ... that has different resolving algorithms ..

URL = str(sys.argv[1])

with open(os.path.expanduser("~/.glue.json")) as fh:
    mapping = json.load(fh)

parsed_url = urllib.parse.urlparse(URL)
# >>> ParseResult(scheme='glue', netloc='test', path='', params='', query='', fragment='')

assert str(parsed_url.scheme.lower()) == "glue", "only glue URLs are supported"

mapped_url = mapping.get(parsed_url.netloc)

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
    print(mapped_url)
