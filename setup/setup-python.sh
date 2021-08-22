#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Create Conda Env ...
( conda env list | grep ${DEFAULT_CONDA_ENV} ) \
	|| conda create -y -n ${DEFAULT_CONDA_ENV} python=3.9 pip

# Install Pip Packages in Virtual Envs ...
${DIR_FOR_BINARIES}/miniconda3/envs/${DEFAULT_CONDA_ENV}/bin/pip install -r "${DIR}/requirements.txt"

