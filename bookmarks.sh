# Get the current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Kill Process with a specific name
ps -aef | grep celery | grep -v grep | cut -f 5 -d ' ' | xargs -I {} bash -c 'echo "killing {}"; kill -9 {}'  

# Remove everything but the last 20 images
docker images -aq | head -n `docker images -q | wc -l | egrep -o '\d+' | xargs -I {} expr {} - 20` | xargs docker rmi -f  

# Remove everything but the last 15 containers
docker ps -aq | head -n `docker ps -aq | wc -l | egrep -o '\d+' | xargs -I {} expr {} - 15` | xargs docker rm -vf 

# Mongo
## To have launchd start mongodb at login:
  ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
## Then to load mongodb now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
## Or, if you don't want/need launchctl, you can just run:
  mongod --config /usr/local/etc/mongod.conf

# Docker
## Create a docker machine
docker-machine create --driver virtualbox promiscuous

