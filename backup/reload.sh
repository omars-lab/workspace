#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# - [x] Set these {DIR_FOR_BINARIES, DIR_FOR_BINARY_REFS, DIR_FOR_GIT} ... or atleast import them ...
source ${CURRENT_DIR}/../variables.sh
source common.sh

export BACKUP_DIR=${DIRS_ENVIRONMENT}/backup/${1:-$(get_uniq_mac_id)}

function relink(){
    echo ${DIR_FOR_BINARIES:?DIR_FOR_BINARIES required.}
    echo ${DIR_FOR_BINARY_REFS:?DIR_FOR_BINARY_REFS required.}
    echo ${DIR_FOR_GIT:?DIR_FOR_GIT required.}
    symlink_if_dne ${DIR_FOR_GIT}/sbt-extras/sbt ${DIR_FOR_BINARY_REFS}/sbt
    symlink_if_dne ${DIR_FOR_GIT}/gocd-scripts/scripts/bin/c12e-ci ${DIR_FOR_BINARY_REFS}/c12e-ci
    symlink_if_dne ${DIR_FOR_GIT}/c12e-sbt-plugin/bin/sbt ${DIR_FOR_BINARY_REFS}/c12e-sbt
    symlink_if_dne ${DIR_FOR_GIT}/c12e-sbt-plugin/bin/c12e-sbt-project ${DIR_FOR_BINARY_REFS}/c12e-sbt-project
    symlink_if_dne ${DIR_FOR_GIT}/c12e-sbt-plugin/bin/c12e-sbt-setup ${DIR_FOR_BINARY_REFS}/c12e-sbt-setup
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/git-2.12.0/git ${DIR_FOR_BINARY_REFS}/git2.12
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongo ${DIR_FOR_BINARY_REFS}/mongo
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongodump ${DIR_FOR_BINARY_REFS}/mongodump
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongoexport ${DIR_FOR_BINARY_REFS}/mongoexport
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongoimport ${DIR_FOR_BINARY_REFS}/mongoimport
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/mongodb-osx-x86_64-3.4.0/bin/mongorestore ${DIR_FOR_BINARY_REFS}/mongorestore
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/orientdb-community-2.2.17/bin/console.sh ${DIR_FOR_BINARY_REFS}/orientdb
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/rancher-compose ${DIR_FOR_BINARY_REFS}/rancher-compose
    symlink_if_dne ${DIR_FOR_BINARIES}/hardfiles/stack-1.2.0-osx-x86_64/stack ${DIR_FOR_BINARY_REFS}/stack1.2
    symlink_by_force ${DIRS_ENVIRONMENT}/profiles/bash_profile "${HOME}/.bash_profile"
    symlink_by_force ${DIRS_ENVIRONMENT}/profiles/vimrc "${HOME}/.vimrc"
    symlink_by_force ${DIRS_ENVIRONMENT}/profiles/zshenv "${HOME}/.zshenv"
    symlink_by_force ${DIRS_ENVIRONMENT}/profiles/zshrc "${HOME}/.zshrc"
}

function install_node_packages(){
    apm install $(cat ${BACKUP_DIR}/packages/atom.txt)
}

function copy_secrets(){
    cp -r ${BACKUP_DIR}/secrets ~/.secrets
    cp -r ${BACKUP_DIR}/ssh ~/.ssh
    cp -r ${BACKUP_DIR}/aws ~/.aws
}

relink