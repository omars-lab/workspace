# DEFAULTS ...
  export DEFAULT_CONDA_ENV=${DEFAULT_CONDA_ENV:-cogenv3}
  
  export DEFAULT_NVM_ENV=${DEFAULT_NVM_ENV:-v18.19.0}

# The docker machine we want to use as defaul for docker-machine
  # export DEFAULT_DOCKER_MACHINE=default

# Editor Stuff
  VISUAL=vim;
  export VISUAL

  EDITOR=vim;
  export EDITOR

# Noteplan
  export NOTEPLAN_LEGACY_HOME=${HOME}/.noteplan
  export NOTEPLAN_HOME=${HOME}/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application\ Support/co.noteplan.NotePlan3

# The path of python site packages
#   export PYTHON_SITE_PACKAGES=/usr/local/lib/python2.7/site-packages

export JAVA_HOME=$(brew --prefix java)

if [[ -d /usr/local/opt/ant ]]
then
    export ANT_HOME=/usr/local/opt/ant
fi
