#!/bin/bash

# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# https://www.home-assistant.io/installation/linux#install-home-assistant-container

function container-from-image-exists() {
	IMAGE="${1}"
	docker ps -q -f "${IMAGE}" \
		| egrep '^[a-zA-Z0-9]{12}$'
}

CONFIG_DIR="${HOME}/.homeassistant"

mkdir -p "${CONFIG_DIR}"A

container-from-image-exists "ancestor=ghcr.io/home-assistant/home-assistant:stable" \
|| docker run -d \
	--name homeassistant \
	--privileged \
	--restart=unless-stopped \
	-e TZ=America/Chicago \
	-v ${CONFIG_DIR}:/config \
	--network=host \
	-p 8123:8123 \
	ghcr.io/home-assistant/home-assistant:stable
