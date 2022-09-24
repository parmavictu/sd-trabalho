#!/bin/bash
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'build.sh' | grep -Po '(?<=-> ).*(?=/build.sh)' | sed 's/ //g'))

_WHERE_AIM=$(pwd)

cd $_ROOT_PATH

docker rmi $(docker images | grep 'none' | awk '{print $3}') &> /dev/null
docker rmi -f $(docker images | grep trabalho-sd | awk '{print $3}') &> /dev/null

docker-compose build --no-cache
docker-compose up

cd $_WHERE_AIM