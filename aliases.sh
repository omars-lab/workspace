# A collection of useful aliases

# Commands to start certain servers
alias START_INFLUX='influxd -config /usr/local/etc/influxdb.conf'

# Sublime Shortcut. Depends on the installation of sublime.
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# Custom File Editors
alias e="subl"
alias editcontainers="vi ${DIRS_ENVIRONMENT}/commands/containers.sh"
alias containers="cat ${DIRS_ENVIRONMENT}/commands/containers.sh"
alias editenvs="vi ${DIRS_ENVIRONMENT}/envmgr/config.json"
alias envs="cat ${DIRS_ENVIRONMENT}/envmgr/config.json"
alias editbookmarks="vi ${DIRS_ENVIRONMENT}/bookmarks.sh"
alias bookmarks="cat ${DIRS_ENVIRONMENT}/bookmarks.sh"
alias editaliases="vi ${DIRS_ENVIRONMENT}/aliases.sh"

alias intellij='/usr/local/bin/idea'

alias chrome='open -a "Google Chrome"'
alias notes="j Notes; atom .; cd -"
alias excel='open -a "Microsoft Excel"'

alias dangling_images='docker images -q -f=dangling=true'
alias dangling_volumes='docker volume ls -q -f dangling=true'
function clean_docker () {
  dangling_images | xargs docker rmi
  dangling_volumes | xargs docker volume rm
}

function js () {
  j $1; /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .;
} 

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gaall='git add'
alias gp='git pull'
alias gc='git commit -am'
alias gd='git diff'
alias gl='git log'

# Docker
alias dc='docker-compose'
alias de='docker exec'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dcs='docker-compose stop'
alias dcr='docker-compose rm'
alias dcl='docker-compose logs'

# alias dps='docker ps'
function dps () {
  # echo "docker ps --format '{{.ID}}, {{.Image}}, {{.Ports}}, {{.Command}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g'"
  # docker ps --format '{{.ID}}, {{.Image}}, {{.Ports}}, {{.Command}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g'
  echo "docker ps --format '{{.ID}}\t{{.Image}}\t{{.Ports}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g' | column -t"
  docker ps --format '{{.ID}}\t{{.Image}}\t{{.Ports}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g' | column -t

}

alias drm='docker rm'
alias drmi='docker rmi'
function drmv () {
  docker volume rm $(docker volume ls -qf dangling=true)
}
alias dr='docker run'
alias db='docker build'
alias di='docker images'

alias dmrestart="docker-machine restart ${DOCKER_MACHINE_NAME:-dev}"
alias dmstop="docker-machine stop ${DOCKER_MACHINE_NAME:-dev}"
alias dmstart="docker-machine start ${DOCKER_MACHINE_NAME:-dev}"
alias dmenv="docker-machine env ${DOCKER_MACHINE_NAME:-dev}"
alias dmls="docker-machine list"



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

# Make tre
alias tre='tree -C -L 1'
