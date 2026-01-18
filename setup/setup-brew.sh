#!/bin/bash

function brew_upstall() {
        brew list "${1}" || brew install "${1}"
}

# Install brew
if ! which brew ;
then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Replaced by brew install omars-lab/tap/scripts

# Install brew packages
# https://github.com/kislyuk/yq

# Required dependencies (used by zshrc and loaders)
brew_upstall jq          # Used in zshrc for conda env checks
brew_upstall python      # Python 3 - used in common.sh for timing
brew_upstall bc          # Used in common.sh for duration calculations

# Optional but commonly used dependencies
# Uncomment if needed:
# brew_upstall autojump   # Directory jumping (used in zshrc)
# brew_upstall asdf       # Version manager (used in zshrc)
# brew_upstall nvm        # Node version manager (used in zshrc)
# brew_upstall maven      # Java build tool (M2_HOME in zshrc)
# brew_upstall watch      # Execute command periodically
# brew_upstall plantuml  # UML diagrams
# brew_upstall the_silver_searcher  # Fast text search (ag)
# brew_upstall tree       # Directory tree view
# brew_upstall python-yq # YAML processor

# Application installations
# test -d /Applications/OpenSCAD.app/ || brew install openscad
# which shortcuts || brew install rodionovd/taps/shortcuts
# brew services start pulseaudio
# brew install pulseaudio
