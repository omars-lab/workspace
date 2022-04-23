#!/bin/bash

INSTALL_PREFIX="${1}"
INSTALL_LOGS=${INSTALL_PREFIX}/install.logs

date >> ${INSTALL_LOGS}
whoami >> ${INSTALL_LOGS}
pwd >> ${INSTALL_LOGS}
env >> ${INSTALL_LOGS}

# Inject into ZSH Profile 
if ( test -f ${HOME}/.zshrc && ! ( grep -q '#tag:inject-brew-loader' ${HOME}/.zshrc) )
then 
    echo 'source $(first $(brew --prefix sharedspace)/loader-brew.sh ${CURRENT_DIR}/loader-brew.sh) #tag:inject-brew-loader' >> ${${HOME}/.zshrc}
    echo "Injected brew loader into zshrc" >> ${INSTALL_LOGS}
fi

# Inject into BASH Profile 
if ( test -f ${HOME}/.bash_profile && ! ( grep -q '#tag:inject-brew-loader' ${HOME}/.bash_profile) )
then 
    echo 'source $(first $(brew --prefix sharedspace)/loader-brew.sh ${CURRENT_DIR}/loader-brew.sh) #tag:inject-brew-loader' >> ${${HOME}/.bash_profile}
    echo "Injected brew loader into bash_profile" >> ${INSTALL_LOGS}
fi
