#!/bin/bash

function brew_upstall() {
        brew list "${1}" || brew install "${1}"
}

# Install brew
if ! which brew ;
then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install brew packages
# https://github.com/kislyuk/yq
brew_upstall python-yq
brew_upstall maven
brew_upstall jq
brew_upstall autojump
brew_upstall asdf
brew_upstall watch
brew_upstall plantuml
brew_upstall the_silver_searcher
brew_upstall nvm
brew_upstall tree

test -d /Applications/OpenSCAD.app/ || brew install openscad
which shortcuts || brew install rodionovd/taps/shortcuts


