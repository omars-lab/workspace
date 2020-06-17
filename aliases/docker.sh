# docker images --filter dangling=true
# docker images --format "{{.Size}}" | sort -n
# docker images --filter "ancestor=cortex_model_test"
# docker images --filter "reference=cortex_model_test" -q

function docker-inspect-command() {
  docker inspect ${1} | jq '.[0].Config' | jq '.Cmd'
}

function docker-inspect-entrypoint() {
  docker inspect ${1} | jq '.[0].Config' | jq '.Entrypoint'
}

function docker-inpsect() {
    docker-inspect-command
    docker-inspect-entrypoint
}

alias docker-dangling-images='docker images -q -f=dangling=true'
alias docker-dangling-volumes='docker volume ls -q -f dangling=true'

function docker-rmis () {
  # docker-dangling-images | xargs docker rmi
  docker rmi $(docker-dangling-images)
}

function docker-rmvs () {
  # docker-dangling-volumes | xargs docker volume rm
  docker volume rm $(docker-dangling-volumes)
}

function docker-clean() {
  docker-rmis
  docker-rmvs
}

# Docker Aliases
alias dc='docker-compose'
alias dr='docker run'
function dps () {
  echo "docker ps --format '{{.ID}}\t{{.Image}}\t{{.Ports}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g' | column -t"
  docker ps --format '{{.ID}}\t{{.Image}}\t{{.Ports}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g' | column -t
}

# alias dm-restart="docker-machine restart ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-stop="docker-machine stop ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-start="docker-machine start ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-env="docker-machine env ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-ls="docker-machine list"
