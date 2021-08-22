#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install XCode ...
test -d "/Applications/Xcode.app/" \
	|| open -a "Safari" https://apps.apple.com/us/app/xcode/id497799835?mt=12

# https://github.com/nodejs/node-gyp/issues/569
# xcode-select --install # Install Command Line Tools if you haven't already.
# sudo xcode-select --switch /Library/Developer/CommandLineTools # Enable command line tools

# https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error/17980786#17980786
# sudo xcode-select -r

