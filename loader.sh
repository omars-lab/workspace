#!/bin/bash

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
# The directory that contains all virtual envs:
    export DIRS_VIRTUAL_ENVS=${DIRS_VIRTUAL_ENVS:-~/environment/virtualenvs}
# The directory that contains the github code:
    export DIRS_GITHUB=${DIRS_GITHUB:-~/git}
# The directoy containing my github environment settings
    export DIRS_ENVIRONMENT=${DIRS_ENVIRONMENT:-${DIRS_GITHUB}/mr-uuid/environment}
# The docker machine we want to use as defaul for docker-machine
    export DEFAULT_DOCKER_MACHINE=default
# All the SSH Keys we want to add, : seperated.
    SSH_KEYS="/Users/oeid/.ssh/github.priv"
    SSH_KEYS+=":/Users/oeid/.ssh/bitbucket.priv"
    SSH_KEYS+=":/Users/oeid/.ssh/foundation-dev-1.pem"
    export SSH_KEYS
# The area where my experiment code lies:
    export DIRS_PLAGROUND='~/playground'
# Determines if the sourcing agent will print or not:
    export SILENT=True
# The path of python site packages
    export PYTHON_SITE_PACKAGES=/usr/local/lib/python2.7/site-packages

source $DIRS_ENVIRONMENT/helpers.sh
source $DIRS_ENVIRONMENT/envmgr/envmgr.sh
source $DIRS_ENVIRONMENT/theme.sh

recursive-source $DIRS_ENVIRONMENT "loader|theme"
recursive-source $DIRS_ENVIRONMENT/commands
recursive-source $DIRS_ENVIRONMENT/git
recursive-source $DIRS_ENVIRONMENT/c12e

# virtualenvwrapper installation:
#  1. Install virtual env: pip install virtualenvwrapper
#  2. Create a directory to hold the virtual environments.
#  3. Add a line like "export WORKON_HOME=<Virtual Envs Home>" to your .bashrc.
#  4. source virtualenvwrapper

# Set the docker envs
dockerwrapper env

# Virtual Env Stuff
export WORKON_HOME=$DIRS_VIRTUAL_ENVS
source $(which virtualenvwrapper.sh)
echo ${VIRTUAL_ENV##*/} | grep 'cogenv' || workon cogenv  # virtualenvwrapper command

# NVM Stuff
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
nvm current | grep 'v4.2.1' || nvm use v4.2.1

# Set right env config
envmgr use omarstest
