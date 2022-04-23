#!/bin/bash

INSTALL_PREFIX="${1:-/usr/local/opt/sharedspace}"
INSTALL_LOGS=${INSTALL_PREFIX}/install.logs
PROFILE_HOME=${CURL_HOME:-${HOME}}

tail ${PROFILE_HOME}/.zshrc >> ${INSTALL_LOGS}

# Inject into ZSH Profile 
if ( test -f ${PROFILE_HOME}/.zshrc && ! ( grep -q '#tag:inject-brew-loader' ${PROFILE_HOME}/.zshrc) )
then 
    echo 'source $(first $(brew --prefix sharedspace)/loader-brew.sh ${CURRENT_DIR}/loader-brew.sh) #tag:inject-brew-loader' >> ${PROFILE_HOME}/.zshrc
    echo "Injected brew loader into zshrc" >> ${INSTALL_LOGS}
fi

# Inject into BASH Profile 
if ( test -f ${PROFILE_HOME}/.bash_profile && ! ( grep -q '#tag:inject-brew-loader' ${PROFILE_HOME}/.bash_profile) )
then 
    echo 'source $(first $(brew --prefix sharedspace)/loader-brew.sh ${CURRENT_DIR}/loader-brew.sh) #tag:inject-brew-loader' >> ${PROFILE_HOME}/.bash_profile
    echo "Injected brew loader into bash_profile" >> ${INSTALL_LOGS}
fi
