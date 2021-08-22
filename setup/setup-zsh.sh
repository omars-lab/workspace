#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install oh my zsh
# https://ohmyz.sh/#install
test -d "${HOME}/.oh-my-zsh" \
	|| sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ZSH Plugins ...
ZSH_PLUGINS=${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins
test -d "${ZSH_PLUGINS}" \
	|| mkdir -p "${ZSH_PLUGINS}"
test -d "${ZSH_PLUGINS}/zsh-completions" \
	|| git clone https://github.com/zsh-users/zsh-completions ${ZSH_PLUGINS}/zsh-completions
test -d "${ZSH_PLUGINS}/antigen" \
	|| git clone https://github.com/zsh-users/antigen ${ZSH_PLUGINS}/antigen

