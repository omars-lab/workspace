# A collection of useful aliases

# Commands to start certain servers
alias START_INFLUX='influxd -config /usr/local/etc/influxdb.conf'

# Sublime Shortcut. Depends on the installation of sublime.
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# Custom File Editors
alias editcontainers="vi ${DIRS_ENVIRONMENT}/commands/containers.sh"
alias editenvs="vi ${DIRS_ENVIRONMENT}/envmgr/config.json"

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gaall='git add'
alias gp='git pull'
alias gc='git commit -am'
alias gd='git diff'
alias gl='git log'

# Docker
alias c='docker-compose'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dcs='docker-compose stop'
alias dcr='docker-compose rm'
alias dcl='docker-compose logs'

alias dps='docker ps'
alias drm='docker rm'
alias drmi='docker rmi'
alias drun='docker run'

# Ease directory traversal. Shouldnt need to go up more than 5 dirs
alias .1='push ../'
alias .2='.1; .1;'
alias .3='.2; .1;'
alias .4='.3; .1;'
alias .5='.4; .1;'

alias p='pushd'
alias o='popd'

# Makes a file Executable
alias x='chmod +x'
