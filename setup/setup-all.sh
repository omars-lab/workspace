#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install Brew Stuff ...
${DIR}/setup-brew.sh

# Install ZSH Stuff ....
${DIR}/setup-zsh.sh

# Install Python stuff ...
${DIR}/setup-python.sh

# Deploying Crontab ...
${DIR}/setup-cron.sh

# Install iterm tools ...
if ! which iterm2_shell_integration.zsh ;
then 
	cd "${HOME}" && ( curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash )
	mv ${HOME}/.iterm2_shell_integration.zsh /usr/local/bin/iterm2_shell_integration.zsh
fi

# Create NVM Env ...
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
nvm list ${DEFAULT_NVM_ENV} \
	|| nvm install ${DEFAULT_NVM_ENV}

# Setup AI configs (move to configfiles and symlink)
${DIR}/setup-ai-configs.sh

# Installing Mac Apps
${DIR}/setup-apps.sh

