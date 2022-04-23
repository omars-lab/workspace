
function docker_keep_last_20_images() {
  # Remove everything but the last 20 images
  docker images -aq | head -n `docker images -q | wc -l | egrep -o '\d+' | xargs -I {} expr {} - 20` | xargs docker rmi -f  
}

function docker_keep_last_15_containers() {
  # Remove everything but the last 15 containers
  docker ps -aq | head -n `docker ps -aq | wc -l | egrep -o '\d+' | xargs -I {} expr {} - 15` | xargs docker rm -vf 
}

function docker_create_machine() {
  ## Create a docker machine
  docker-machine create --driver virtualbox promiscuous
}

function mongo_register_as_login_service() {
  ## To have launchd start mongodb at login:
  ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
}

function monto_start() {
  ## Then to load mongodb now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
  ## Or, if you don't want/need launchctl, you can just run:
  mongod --config /usr/local/etc/mongod.conf
}