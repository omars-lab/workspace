# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------

CURRENT_DIR=${0:a:h}

source ${CURRENT_DIR}/common.sh
source ${CURRENT_DIR}/overrides/$(get_uniq_mac_id)/variables.sh
# These variables are not relevant to local dir so they can be imported by any script ...

# The directory that contains the Workspace
  export DIRS_WORKSPACE=${DIRS_WORKSPACE:-${HOME}/Workspace}
# The directory that contains all virtual envs:
  export DIRS_VIRTUAL_ENVS=${DIRS_VIRTUAL_ENVS:-${DIRS_WORKSPACE}/venvs}
# The directory that contains the github code:
  export DIRS_GIT=${DIRS_GIT:-${DIRS_WORKSPACE}/git}
# The directoy containing my github environment settings
  export DIRS_ENVIRONMENT=${DIRS_ENVIRONMENT:-${DIRS_GIT}/environment}
# The area where my experiment code lies:
  export DIRS_PLAGROUND="${DIRS_GIT}/playground"
# The area where my raw binaries lie:
  export DIR_FOR_BINARIES="${DIRS_WORKSPACE}/binaries"
# The area where my binary refs lie:
  export DIR_FOR_BINARY_REFS="${DIRS_WORKSPACE}/binary-refs"
# The area where my backups are:
  export DIR_FOR_BACKUPS="${DIRS_ENVIRONMENT}/backup"
# The docker machine we want to use as defaul for docker-machine
  # export DEFAULT_DOCKER_MACHINE=default

# Depreciated in favor of .ssh/config
# All the SSH Keys we want to add, : seperated.
  # SSH_KEYS="/Users/oeid/.ssh/github_work"
  # SSH_KEYS+=":/Users/oeid/.ssh/bitbucket"
  # SSH_KEYS+=":/Users/oeid/.ssh/jumpcloud"
  # SSH_KEYS+=":/Users/oeid/.ssh/nifi-foundation.priv"
  # SSH_KEYS+=":/Users/oeid/.ssh/foundation-dev-1.pem"
  # export SSH_KEYS
  # PERSONAL_SSH_KEYS="/Users/oeid/.ssh/github"
  # PERSONAL_SSH_KEYS+=":/Users/oeid/.ssh/bitbucket-personal"
  # export PERSONAL_SSH_KEYS

# Determines if the sourcing agent will print or not:
  export SILENT=False

# Editor Stuff
  VISUAL=atom;
  export VISUAL

  EDITOR=atom;
  export EDITOR

# The path of python site packages
#   export PYTHON_SITE_PACKAGES=/usr/local/lib/python2.7/site-packages
