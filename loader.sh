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

recursive-source $DIRS_ENVIRONMENT "loader|theme"
recursive-source $DIRS_ENVIRONMENT/commands
# recursive-source $DIRS_ENVIRONMENT/git
recursive-source $DIRS_ENVIRONMENT/c12e ".sh"

# Set the docker envs
dockerwrapper env

# Virtual Env Stuff
export WORKON_HOME=$DIRS_VIRTUAL_ENVS
source $(which virtualenvwrapper.sh)
echo ${VIRTUAL_ENV##*/} | grep 'cogenv' || workon cogenv  # virtualenvwrapper command

export PATH="$PATH:$VIRTUAL_ENV/bin"

# NVM Stuff
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
nvm current | grep 'v4.2.1' || nvm use v4.2.1

# Set right env config
envmgr use omarstest
