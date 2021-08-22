#!/usr/bin/env python3.7

# https://stackoverflow.com/questions/17651017/python-post-osx-notification

import os

def notify(title, text):
    os.system("""
              osascript -e 'display notification "{}" with title "{}"'
              """.format(text, title))

notify("Title", "Heres an alert")

