#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Deploying Crontab ...

if ! ( crontab -l | grep ".sh" ) ;
then 
  ${DIR}/../crontab/generate-cronfile | crontab -
fi

