#!/usr/bin/env python3

import sys

indent = 0

for c in sys.stdin.read():
    if c == "{":
        tabs = "\t"*indent
        indent = indent + 1
        print()
        print(f"{tabs}{c}\n{tabs}", end="")
    elif c == "}":
        indent = indent - 1
        tabs = "\t"*indent
        print()
        print(f"{tabs}{c}\n{tabs}", end="")
    else: 
        tabs = "\t"*indent
        print(f"{c}", end="")
