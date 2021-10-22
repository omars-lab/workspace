SHELL := /bin/bash
MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
APP_HOME := $(shell cd ${MAKEFILE_DIR}/../../.. && pwd)

# https://janostlund.com/2018-07-12/url-schemes
# https://code.visualstudio.com/docs/editor/command-line#_opening-vs-code-with-urls

app_home:
	echo ${APP_HOME}

install:
	test -L /Applications/Glue.app || ln -s ${APP_HOME} /Applications/Glue.app

setup: install 
	test -L ~/.glue.json || ln -s ${MAKEFILE_DIR}/glue.json ~/.glue.json

test: setup
	open glue://test
	open glue://test2
	open glue://vscode-folder
	open glue://vscode-file
	open glue://vscode-cursor
