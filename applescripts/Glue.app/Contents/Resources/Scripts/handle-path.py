import urllib.parse
import sys
import os.path 
import json
import logging as log
import subprocess


def warn(title, short_msg, long_msg): 
    # https://code-maven.com/display-notification-from-the-mac-command-line
    # https://www.pythongasm.com/desktop-notifications-with-python/
    command = f'''
    osascript -e 'display notification "{short_msg}" with title "WARNING: {title}"'
    '''
    os.system(command)
    log.warning(long_msg)

def not_found_mapper(x):
    return "https://www.disney.com/404"

def grep_ril(directory, term):
    log.debug(directory)
    log.debug(term)
    # https://stackoverflow.com/questions/7607879/git-grep-and-word-boundaries-on-mac-os-x-and-bsd
    # https://www.warp.dev/terminus/grep-in-directory#grep-r-vs-R
    command = [
        '/usr/local/bin/ggrep', '-Rilw', f"{term}", f'{directory}'
    ]
    log.debug(" ".join(command))
    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE, 
        stderr=subprocess.PIPE
    )
    stdout, stderr = process.communicate()
    return ([x for x in stdout.decode().strip().split("\n") if x], stderr.decode().strip().split("\n"))

def open_json(filename):
    with open(filename) as fh:
        return json.load(fh)

DIRS_WITH_TAGS=["blueprints"]

# - [x] Add the notion of a resolver ... that has different resolving algorithms .. @done(2023-01-09T08:18:17-06:00)
def get_mapper(url):
    if url.netloc == "initiatives":
        return (lambda x: open_json("/Applications/Glue.app/Contents/Resources/Scripts/glue.initiatives.json")[x])
    # if url.netloc == "habits":
    #     return (lambda x: open_json("/Applications/Glue.app/Contents/Resources/Scripts/glue.habits.json")[x])
    if url.netloc in DIRS_WITH_TAGS and not url.fragment:
        search_dir = os.path.expanduser(f"~/workplace/git/{url.netloc}")
        return (lambda x: f"vscode://file/{search_dir}/{x}")
    if url.netloc in DIRS_WITH_TAGS and url.fragment:
        search_dir = os.path.expanduser(f"~/workplace/git/{url.netloc}")
        results, errs = grep_ril(search_dir, url.fragment)
        if len(results) < 1:
            log.error(f"No results found for grep [{url.fragment}] in [{search_dir}]")
            # Add a debugging screen here ... 
            # return not_found_mapper
            return lambda x: f"file://{search_dir}"
        elif len(results) > 1:
            warn(
                f"id not unique", 
                f"#{url.fragment} occurs {len(results)} times in {search_dir}", 
                f"More than 1 result for grep {url.fragment}, taking first result from: {results}"
            )
        log.debug(f"STDOUT {results}")
        log.debug(f"STDERR {errs}")
        return (lambda x: f"vscode://file/{results[0]}")
    return (lambda x: open_json(os.path.expanduser("~/.glue.json"))[x])

def open_url(argv, url):
    # os.system(f"""
    #     open "{url}";
    # """)
    # echo "[{argv}]" > /tmp/glue.txt ;
    # echo "{url}" > /tmp/glue.url
    pass

def main():
    log.debug("Start")
    URL = str(sys.argv[1])

    parsed_url = urllib.parse.urlparse(URL)
    # >>> ParseResult(scheme='glue', netloc='test', path='', params='', query='', fragment='')

    assert str(parsed_url.scheme.lower()) == "glue", "only glue URLs are supported"

    mapper = get_mapper(parsed_url)
    mapped_url = mapper(parsed_url.path[1:])

    # https://github.com/shengyou/vscode-handler

    if mapped_url is None:
        warn("Glue Got Stuck", f"No mapping found for: {URL}", f"No mapping found for: {URL}")
        print("https://www.disney.com/404")
    else:
        # https://www.urlencoder.io/python/
        # print(urllib.parse.quote(mapped_url, safe=''))
        # open_url(sys.argv, mapped_url)
        print(mapped_url)

if __name__ == "__main__":
    log.basicConfig(
        filename=os.path.expanduser("~/.glue/glue.log"), 
        encoding='utf-8', 
        level=log.DEBUG, 
        format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',
        datefmt='%Y-%m-%dT%H:%M:%S'
    )
    try:
        main()
    except Exception as e:
        log.error(f"Exception: {e}")

# /usr/local/bin/python3 /Applications/Glue.app/Contents/Resources/Scripts/handle-path.py ""