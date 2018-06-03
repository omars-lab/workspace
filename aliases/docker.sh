# docker images --filter dangling=true
# docker images --format "{{.Size}}" | sort -n
# docker images --filter "ancestor=cortex_model_test"
# docker images --filter "reference=cortex_model_test" -q

function d-inspect-command() {
  docker inspect ${1} | jq '.[0].Config' | jq '.Cmd'
}

function d-inspect-entrypoint() {
  docker inspect ${1} | jq '.[0].Config' | jq '.Entrypoint'
}

alias d-dangling-images='docker images -q -f=dangling=true'
alias d-dangling-volumes='docker volume ls -q -f dangling=true'

function d-rm-i () {
  # d-dangling-images | xargs docker rmi
  docker rmi $(d-dangling-images)
}

function d-rm-v () {
  # d-dangling-volumes | xargs docker volume rm
  docker volume rm $(d-dangling-volumes)
}

function d-clean() {
  d-rm-i
  d-rm-v
}

# Docker
alias dc='docker-compose'

# alias dps='docker ps'
function dps () {
  echo "docker ps --format '{{.ID}}\t{{.Image}}\t{{.Ports}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g' | column -t"
  docker ps --format '{{.ID}}\t{{.Image}}\t{{.Ports}}' $@ | sed -e 's/0.0.0.0://g' -e 's+/tcp++g' | column -t
}

alias dr='docker run'

# alias dm-restart="docker-machine restart ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-stop="docker-machine stop ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-start="docker-machine start ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-env="docker-machine env ${DOCKER_MACHINE_NAME:-dev}"
# alias dm-ls="docker-machine list"

