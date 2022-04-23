#!/bin/bash

# Inject into ZSH Profile 
if ( test -f ${HOME}/.zshrc && ! ( grep -q '#tag:inject-brew-loader' ${HOME}/.zshrc) )
then 
    echo 'source $(first $(brew --prefix sharedspace)/loader-brew.sh ${CURRENT_DIR}/loader-brew.sh) #tag:inject-brew-loader' >> ${${HOME}/.zshrc}
fi

# Inject into BASH Profile 
if ( test -f ${HOME}/.bash_profile && ! ( grep -q '#tag:inject-brew-loader' ${HOME}/.bash_profile) )
then 
    echo 'source $(first $(brew --prefix sharedspace)/loader-brew.sh ${CURRENT_DIR}/loader-brew.sh) #tag:inject-brew-loader' >> ${${HOME}/.bash_profile}
fi
