#!/usr/bin/env python3

#!/bin/bash brew-python
# https://scriptingosx.com/2017/10/on-the-shebang/
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# https://bash.cyberciti.biz/guide/Shebang
# https://www.in-ulm.de/~mascheck/various/shebang/

# Foreground Colors
RED = '\x1b[31m'
GREEN = '\x1b[32m'
ORANGE = '\x1b[33m'
BLUE = '\x1b[34m'
PURPLE = '\x1b[35m'
CYAN = '\x1b[36m'

# Styles
BOLD = '\x1b[1m'
DIM = '\x1b[2m'
ITALIC = '\x1b[3m'
UNDERLINE = '\x1b[4m'
BLINK = '\x1b[5m'
INVERT = '\x1b[7m'
STRIKETHROUGH = '\x1b[9m'

# Background Colors
BG_BLACK = '\x1b[40m'
BG_RED = '\x1b[41m'
BG_GREEN = '\x1b[42m'
BG_YELLOW = '\x1b[43m'
BG_BLUE = '\x1b[44m'
BG_MAGENTA = '\x1b[45m'
BG_CYAN = '\x1b[46m'

END_COLOR = '\x1b[0m'

# Todo ... markdown to bash formatting!

def blue(s:str) -> str:
	return f"{GREEN}{s}{END_COLOR}"

def test(s:str) -> str:
	return f"{RED}{BG_MAGENTA}{INVERT}{ITALIC}{UNDERLINE}{s}{END_COLOR}"

print(test("hello"))

