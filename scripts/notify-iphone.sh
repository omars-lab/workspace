#!/bin/bash

# https://apple.stackexchange.com/questions/8906/sending-push-notification-to-iphone-via-applescript
# https://www.macworld.com/article/223328/if-this-then-that-automator-ios-notifications-awesome.html

# Limited to 1000 calls an hour https://www.prowlapp.com/api.php#add
# Emojis Work
# Displayed as:
# {application}-{event}
# {description}

DESCRIPTION=${1:-Test Notification}
EVENT=${2:-Test Event}
APPLICATION=${3:-🚨Mac Mini 🚨}

set -x
# Posts growl notifications to iOS device using prowl & curl

# Fill in with your own Prowl API key here and remove 123456789
APIKEY=$(cat ~/.secrets/prowl-api-key)

# Post notification to Prowl using curl
curl -s --globoff https://api.prowlapp.com/publicapi/add \
  -H Accept="content/json" \
  -F apikey=$APIKEY \
  -F application="${APPLICATION}" \
  -F event="  ${EVENT}" \
  -F description="${DESCRIPTION}"
  > /dev/null

