# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------

if [ -n "$ZSH_VERSION" ]; then
  CURRENT_DIR=${0:a:h}
elif [ -n "$BASH_VERSION" ]; then
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
else
   exit 1
fi

source ${CURRENT_DIR}/common.sh >/dev/null
source ${CURRENT_DIR}/overrides/$(get_uniq_mac_id)/variables.sh
# These variables are not relevant to local dir so they can be imported by any script ...
# - [ ] Only Source if the override dir exists along with the variables file ...

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
# The area where hand writtern helper scripts are kept:
  export DIR_FOR_SCRIPTS="${DIRS_ENVIRONMENT}/scripts"

# For Apps ...
  if [[ -d ${HOME}'/Dropbox (Personal)' ]] ; then
  	export DIR_FOR_IA_WRITER=${HOME}'/Dropbox (Personal)/Apps/iA Writer/'
  else 
  	export DIR_FOR_IA_WRITER=${HOME}'/Dropbox/Apps/iA Writer/'
  fi
  export DIR_FOR_IA_WRITER_ICLOUD=${HOME}/Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents/

# DEFAULTS ...
  export DEFAULT_CONDA_ENV=${DEFAULT_CONDA_ENV:-cogenv3}
  export DEFAULT_NVM_ENV=${DEFAULT_NVM_ENV:-v8.12.0}
# The docker machine we want to use as defaul for docker-machine
  # export DEFAULT_DOCKER_MACHINE=default

# iCloud Specific Settings
# The location of icloud files on my local machine
  export ICLOUD_ROOT=$(echo ${HOME}'/Library/Mobile Documents')
# The email that is associated with my icloud ...
# - [-] Ensure this email file is created if it doesnt exist ...
#   export ICLOUD_EMAIL=${ICLOUD_EMAIL:-$(cat "${ICLOUD_ROOT}/email.txt")}
  # echo Using iCloud Email: ${ICLOUD_EMAIL:?ICLOUD EMAIL Required} 1>&2
# The location of the directory I will backup icloud too ...
  export ICLOUD_BACKUP_DIR="${DIRS_ENVIRONMENT}/backup/iCloud/${ICLOUD_EMAIL}"
# Personal iCloud Email
  export ICLOUD_PERSONAL_EMAIL=omar_eid21@yahoo.com
# Work iCloud Email
  export ICLOUD_WORK_EMAIL=oeid@cognitivescale


# Backup Specific Settings ...

# The directory to backup noteplan from ....
  export NOTEPLAN_ICLOUD_DIR="${ICLOUD_ROOT}/iCloud~co~noteplan~NotePlan/Documents"
# The directory to backup noteplan to ...
  export NOTEPLAN_GIT_DIR="${ICLOUD_BACKUP_DIR}/Noteplan"

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
  VISUAL=vim;
  export VISUAL

  EDITOR=vim;
  export EDITOR

# The path of python site packages
#   export PYTHON_SITE_PACKAGES=/usr/local/lib/python2.7/site-packages

# Path Exports ...
export PATH=${PATH}:${DIR_FOR_SCRIPTS}/
