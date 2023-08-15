#!/bin/bash

SECRETS=$(mktemp)
lpass ls automation | egrep -o '\[id: (\d+)\]' | egrep -o '\d+' | xargs lpass show -j | jq 'map(select(.name|contains("api-key")))' > ${SECRETS}
mkdir -p ~/.secrets
jq -cr --arg singleQuote "'" '.[] | "bash -c \($singleQuote)echo \(.note)  > ${HOME}/.secrets/\(.name)\($singleQuote)"' ${SECRETS} \
	| sh
rm ${SECRETS}
