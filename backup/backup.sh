#!/bin/bash

source common.sh

export BACKUP_DIR=${PWD}/$(get_uniq_mac_id)

# - [ ] Set these two ... or atleast import them ...
# DIR_FOR_BINARIES
# DIR_FOR_GIT

function save_mac_info(){
    mkdir -p ${BACKUP_DIR}
    system_profiler SPHardwareDataType > ${BACKUP_DIR}/info.txt
}

function backup_dot_files(){
    mkdir -p ${BACKUP_DIR}/dotfiles
    cp ~/.gitignore_global ${BACKUP_DIR}/dotfiles/gitignore_global
    cp ~/.npmrc ${BACKUP_DIR}/dotfiles/npmrc
    cp -r ~/.ssh ${BACKUP_DIR}/dotfiles/ssh
    cp -r ~/.secrets ${BACKUP_DIR}/dotfiles/secrets
    cp -r ~/.aws ${BACKUP_DIR}/dotfiles/aws
    ls -1 ~/.*hist* | xargs -I {} bash -c \
        'cp ${0} "${1}/$(basename ${0} | sed s/^.//g)" ' '{}' "${BACKUP_DIR}/dotfiles/"
}

function backup_atom_config()(
    mkdir -p ${BACKUP_DIR}/configs/atom
    cp ${HOME}/.atom/*.cson ${BACKUP_DIR}/configs/atom/
    cp ${HOME}/.atom/*.less ${BACKUP_DIR}/configs/atom/
)

function backup_brew_config()(
    mkdir -p ${BACKUP_DIR}/configs/brew
    brew tap > ${BACKUP_DIR}/configs/brew/taps.txt
)

function backup_robo3t_config()(
    # This was located initially in .3T/robo-3t/1.1.1/robo3t.json
    mkdir -p ${BACKUP_DIR}/configs/robo3t
    cp ~/.3T/robo-3t/1.1.1/robo3t.json config.json
)

function backup_atom_packages(){
    mkdir -p ${BACKUP_DIR}/packages
    apm list --installed --bare > ${BACKUP_DIR}/packages/atom.txt
}

function backup_virtualenv_packages(){
    mkdir -p ${BACKUP_DIR}/packages/virtualenv
    find ${VIRTUALENVWRAPPER_HOOK_DIR} -type d -d 1 -exec \
        bash -c 'export VIRTUAL_ENV_NAME=$(basename ${0}); ${0}/bin/pip freeze > "${1}/${VIRTUAL_ENV_NAME}.txt" ' \
        '{}' "${BACKUP_DIR}/packages/virtualenv" \;
}

function backup_conda_packages(){
    mkdir -p ${BACKUP_DIR}/packages/conda
    conda-env list --json | jq -r '.envs | .[]' | xargs -I {} \
        bash -c 'export VIRTUAL_ENV_NAME=$(basename ${0}); ${0}/bin/pip freeze > "${1}/${VIRTUAL_ENV_NAME}.txt" ' \
        '{}' "${BACKUP_DIR}/packages/conda"
}

function backup_brew_packages(){
    mkdir -p ${BACKUP_DIR}/packages
    brew list -1 > ${BACKUP_DIR}/packages/brew.txt
}

function backup_vim_packages(){
    mkdir -p ${BACKUP_DIR}/packages/vim
    find ~/.vim/bundle -type d -d 1 -exec bash -c \
        'git -C ${0} remote show origin > ${1}/$(basename ${0}).txt' \
        '{}' "${BACKUP_DIR}/packages/vim" \;
}

function backup_git_dir(){
    GITDIR=$(dirname ${1})
    DEST_DIR=${2}/$(basename ${GITDIR})
    mkdir -p ${DEST_DIR}
    # Extract the url, and append -personal (could also determine this by the path of the gitrepo ...)
    PERSONAL_SUFFIX=$(echo ${GITDIR} | grep -o personal 1>/dev/null && echo -n '-personal' || echo -n '')
    cat ${GITDIR}/.git/config \
        | grep 'url =' \
        | egrep -o 'git@.*' \
        | sed "s/[.]com:/.com${PERSONAL_SUFFIX}:/g" \
        | sed "s/[.]org:/.org${PERSONAL_SUFFIX}:/g" \
        | sed "s#[.]org/#.org${PERSONAL_SUFFIX}:#g" \
        > ${DEST_DIR}/repo.txt
    git -C ${GITDIR} status > ${DEST_DIR}/status.txt
    echo ${0} > ${DEST_DIR}/path.txt
    git -C ${GITDIR} stash list > ${DEST_DIR}/stashes.txt
    
}
export -f backup_git_dir

function backup_git_repos() {
    mkdir -p ${BACKUP_DIR}/repos
    find ~/git -name '.git' -type d -exec bash -c \
        'backup_git_dir "${0}" "${1}"' '{}' "${BACKUP_DIR}/repos" \;
    
}

function backup_mac_app_names(){
  {  
      find ${HOME}/Library -name '*.app' -maxdepth 2 2>/dev/null \
    & find /Library -name '*.app' -maxdepth 2 2>/dev/null \
    & find /Applications -name '*.app' -maxdepth 2 2>/dev/null \
    & find ${HOME}/Applications -name '*.app' -maxdepth 2 2>/dev/null \
    ; 
  } | sort | uniq | egrep -v '.localized[/]' > ${BACKUP_DIR}/apps.txt
}

function relink(){
    cd ${DIR_FOR_BINARIES:?DIR_FOR_BINARIES required.}
    ln -s ${DIR_FOR_GIT:?DIR_FOR_GIT required.}/sbt-extras/sbt sbt
    ln -s ${DIR_FOR_GIT}/gocd-scripts/scripts/bin/c12e-ci c12e-ci
    ln -s ${DIR_FOR_GIT}/c12e-sbt-plugin/bin/sbt c12e-sbt
    ln -s ${DIR_FOR_GIT}/c12e-sbt-plugin/bin/c12e-sbt-project c12e-sbt-project
    ln -s ${DIR_FOR_GIT}/c12e-sbt-plugin/bin/c12e-sbt-setup c12e-sbt-setup
    ln -s hardfiles/git-2.12.0/git git2.12
    ln -s hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongo mongo
    ln -s hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongodump mongodump
    ln -s hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongoexport mongoexport
    ln -s hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongoimport mongoimport
    ln -s hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongorestore mongorestore
    ln -s hardfiles/orientdb-community-2.2.17/bin/console.sh orientdb
    ln -s hardfiles/rancher-compose rancher-compose
    ln -s hardfiles/stack-1.2.0-osx-x86_64/stack stack1.2
}
 
function backup_executables(){
    mkdir -p ${BACKUP_DIR}
    compgen -c | sort | uniq > ${BACKUP_DIR}/executables.txt
}

function backup_docker_images(){
    mkdir -p ${BACKUP_DIR}
    docker images > ${BACKUP_DIR}/docker-images.txt
}

# save_mac_info \
#     && backup_mac_app_names \
#     && backup_atom_config \
#     && backup_brew_config \
#     && backup_robo3t_config \
#     && backup_atom_packages \
#     && backup_brew_packages \
#     && backup_vim_packages \
#     && backup_conda_packages \
#     && backup_virtualenv_packages \
#     && backup_vim_packages \
#     && backup_git_repos
         backup_dot_files \
      && backup_executables \
      && backup_docker_images