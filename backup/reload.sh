#!/bin/bash

source common.sh

export BACKUP_DIR=${PWD}/${1:-$(get_uniq_mac_id)}

# - [ ] Set these two ... or atleast import them ...
# DIR_FOR_BINARIES
# DIR_FOR_GIT

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

function install_node_packages(){
    apm install $(cat ${BACKUP_DIR}/packages/atom.txt)
}
