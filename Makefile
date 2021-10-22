SHELL := /bin/bash
MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CONDA_ENV := $$(basename $${PWD})
.PHONY: setup activate 

setup:
	conda create -n "${CONDA_ENV}" python=3.7 pip -y
	conda run -n "${CONDA_ENV}" pip install -r ${MAKEFILE_DIR}/requirements.txt

activate:
	@ echo conda activate $$(basename ${PWD})

create-formula:
	# Please run `brew audit --new workspace` before submitting, thanks.
	# Editing /usr/local/Homebrew/Library/Taps/omars-lab/homebrew-tap/Formula/workspace.rb
	brew create --tap omars-lab/tap https://github.com/omars-lab/workspace/archive/refs/tags/v0.0.tar.gz

install-links:
	test -L ~/.zshrc || echo "Need to set zshrc"
	test -L ~/.bash_profile || echo "Need to set bash_profile"
