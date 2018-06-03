# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------

# The directory that contains all virtual envs:
  export DIRS_VIRTUAL_ENVS=${DIRS_VIRTUAL_ENVS:-~/environment/virtualenvs}
# The directory that contains the github code:
  export DIRS_GITHUB=${DIRS_GITHUB:-~/git}
# The directory containing my personal code
  export DIRS_CODE=${DIRS_ENVIRONMENT:-${DIRS_GITHUB}/personal-code}
# The directoy containing my github environment settings
  export DIRS_ENVIRONMENT=${DIRS_ENVIRONMENT:-${DIRS_CODE}/environment}
# The docker machine we want to use as defaul for docker-machine
  export DEFAULT_DOCKER_MACHINE=default
# All the SSH Keys we want to add, : seperated.
  SSH_KEYS="/Users/oeid/.ssh/github_work"
  SSH_KEYS+=":/Users/oeid/.ssh/bitbucket"
  SSH_KEYS+=":/Users/oeid/.ssh/jumpcloud"
  # SSH_KEYS+=":/Users/oeid/.ssh/nifi-foundation.priv"
  # SSH_KEYS+=":/Users/oeid/.ssh/foundation-dev-1.pem"
  export SSH_KEYS
  PERSONAL_SSH_KEYS="/Users/oeid/.ssh/github"
  PERSONAL_SSH_KEYS+=":/Users/oeid/.ssh/bitbucket-personal"
  export PERSONAL_SSH_KEYS
# The area where my experiment code lies:
  export DIRS_PLAGROUND='${DIRS_CODE}/playground/'
# Determines if the sourcing agent will print or not:
  export SILENT=False
# Editor Stuff
  VISUAL=atom; export VISUAL
  EDITOR=atom; export EDITOR
# The path of python site packages
  export PYTHON_SITE_PACKAGES=/usr/local/lib/python2.7/site-packages
