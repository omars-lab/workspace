# This is imported in a particular order ...

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
  export DIR_FOR_BINARIES="/usr/local/bin"
# The area where my binary refs lie:
  export DIR_FOR_BINARY_REFS="${DIRS_WORKSPACE}/binary-refs"
# The area where my backups are:
  export DIR_FOR_BACKUPS="${DIRS_ENVIRONMENT}/backup"
# The area where hand writtern helper scripts are kept:
  export DIR_FOR_SCRIPTS="${DIRS_ENVIRONMENT}/scripts"
# The area where hand writtern helper scripts are kept:
  export DIR_FOR_CAREER_WORKSPACE="${DIRS_GIT}/workspace-career"

# Dirs for Apps ...
  if [[ -d ${HOME}'/Dropbox (Personal)' ]] ; then
  	export DIR_FOR_IA_WRITER=${HOME}'/Dropbox (Personal)/Apps/iA Writer/'
  else
  	export DIR_FOR_IA_WRITER=${HOME}'/Dropbox/Apps/iA Writer/'
  fi

  export DIR_FOR_IA_WRITER_ICLOUD=${HOME}/Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents/

# The directory to backup noteplan from ....
  export NOTEPLAN_ICLOUD_DIR="${ICLOUD_ROOT}/iCloud~co~noteplan~NotePlan/Documents"
# The directory to backup noteplan to ...
  export NOTEPLAN_GIT_DIR="${ICLOUD_BACKUP_DIR}/Noteplan"

  export NVM_DIR=${DIR_FOR_BINARIES}/nvm