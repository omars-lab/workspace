#!/bin/bash

# loader.sh:
# Contains the stuff that needs to be imported first that other stuff uses.
# Ensures to import stuff in the correct order

# CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

eval "$(cat $(dirname $0)/variables.sh)"

source $DIRS_ENVIRONMENT/helpers.sh
source $DIRS_ENVIRONMENT/envmgr/envmgr.sh
source $DIRS_ENVIRONMENT/theme.sh
source $DIRS_ENVIRONMENT/ifttt/maker.sh
source $DIRS_ENVIRONMENT/ifttt/functions.sh

recursive-source $DIRS_ENVIRONMENT "loader|theme|bookmarks"
recursive-source $DIRS_ENVIRONMENT/commands
recursive-source $DIRS_ENVIRONMENT/aliases
recursive-source $DIRS_ENVIRONMENT/scripts

# recursive-source $DIRS_ENVIRONMENT/c12e
# recursive-source $DIRS_ENVIRONMENT/git

# Python Virtual Env Stuff
export WORKON_HOME=$DIRS_VIRTUAL_ENVS
source $(which virtualenvwrapper.sh)
export PATH="$PATH:$VIRTUAL_ENV/bin"
echo ${VIRTUAL_ENV##*/} | grep 'cogenv' || workon cogenv  # virtualenvwrapper command

# NVM Stuff
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
(nvm current | grep 'v4.7.3') || nvm use v4.7.3

# Setup the env
# envmgr use omarstest
