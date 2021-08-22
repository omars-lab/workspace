#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# - [x] Set these {DIR_FOR_BINARIES, DIR_FOR_BINARY_REFS, DIRS_GIT} ... or atleast import them ...
source ${CURRENT_DIR}/../variables.sh
source common.sh

export BACKUP_DIR=${DIRS_ENVIRONMENT}/backup/${1:-$(get_uniq_mac_id)}


function install_zsh_iterm_integration(){
  curl -L https://iterm2.com/shell_integration/zsh \
    -o ${DIR_FOR_BINARIES}/iterm2_shell_integration.zsh
}

function install_atom_packages(){
    apm install $(cat ${BACKUP_DIR}/packages/atom.txt)
}

function install_vim_packages(){
    # Instructions here: https://github.com/tpope/vim-pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
      curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function install_vim_bundles(){
    find ${BACKUP_DIR}/packages/vim -name '*.txt' -exec cat {} \; | grep 'Fetch URL:' | sed -E 's#https?://.*.(com|org)/##g' | sed 's#[^:]*: *##g' \
        | xargs -I {} bash -c 'VIM_GIT_DIR=${1}/$(basename ${0}); test -d ${VIM_GIT_DIR} || mkdir -p ${VIM_GIT_DIR} && git clone git@github.com:${0} "${VIM_GIT_DIR}"' '{}' "${HOME}/.vim/bundle"
}

function install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function install_oh_my_zsh_plugins(){
    mkdir -p $(dirname ~/.oh-my-zsh/plugins/antigen/antigen.zsh)
    curl -L git.io/antigen > ~/.oh-my-zsh/plugins/antigen/antigen.zsh
}

function install_nvm_versions()(
    . "$(brew --prefix)/opt/nvm/nvm.sh"
    nvm install v8.9.2
    nvm install v6.2.0
)

function install_virtual_envs(){
  conda create -n cogenv3 python=3.6
  conda create -n cogenv python=2.7
}

function copy_secrets(){
    cp -r ${BACKUP_DIR}/secrets ~/.secrets
    cp -r ${BACKUP_DIR}/ssh ~/.ssh
    cp -r ${BACKUP_DIR}/aws ~/.aws
}

install_virtual_envs

#    install_zsh_iterm_integration \
# && install_nvm_versions \
# && install_atom_packages \
# && install_vim_packages \
# && install_vim_bundles \
# && install_oh_my_zsh \
# && install_oh_my_zsh_plugins \
# && install_nvm_versions \
# && copy_secrets
