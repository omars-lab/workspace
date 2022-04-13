#!/bin/bash

cat 2>&1 | sed -E -e 's#File "/(.*)", line ([0-9]+)#vscode://file/\1:\2#'
