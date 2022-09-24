#!/bin/bash
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'start.sh' | grep -Po '(?<=-> ).*(?=/start.sh)' | sed 's/ //g'))

_WHERE_AIM=$(pwd)

cd $_ROOT_PATH

eval $(minikube docker-env)

docker rmi $(docker images | grep 'none' | awk '{print $3}') &> /dev/null
docker rmi -f $(docker images | grep trabalho-sd | awk '{print $3}') &> /dev/null

docker-compose build --no-cache

eval $(minikube docker-env -u)

cd $_WHERE_AIM