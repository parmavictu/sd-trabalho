#!/bin/bash
#
# Exemplo: environment/docker/start-compose.sh \
#                 --command='"node", "server.js"' \
#                 --app-src='"./"'
#
_PROJETC_PATH='./../../'
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | grep 'start-compose.sh' | grep -Po '(?<=-> ).*(?=/start-compose.sh)' | sed 's/ //g'))
_WHERE_AIM=$(pwd)

cd $_ROOT_PATH

source ./../../sh/utils.sh

_ENV='.env'

if $(HasFlag --value='prod' "$@"); then
  LoggerInfo 'Environment: prod...'
  _ENV=".prod${_ENV}"
fi

cp ./../src/config/environment/${_ENV} .env

sed -i 's/export //g' .env

source .env

echo -e '\n\n'
while IFS= read -r ENVS
do
  if [[ ! -z $(echo $ENVS | egrep '^#(.*)') ]] || [[ -z $ENVS ]]; then
    continue
  fi
  eval "echo $ENVS"
done < ".env"
echo -e '\n\n'

if $(HasFlag --value='k8s' --upper-flag='K' "$@"); then
  StartMinikube
  
  LoggerInfo 'Startando: docker-compose build...'
  eval $(minikube docker-env)

  docker rmi $(docker images | grep 'none' | awk '{print $3}') &> /dev/null
  docker rmi -f $(docker images | grep $ENV_INSTANCE_NAME | awk '{print $3}') &> /dev/null

  docker-compose build --no-cache

  eval $(minikube docker-env -u)
else
  LoggerInfo 'Startando: docker-compose build...'
  docker-compose build --no-cache

  if $(HasFlag --value='up' --upper-flag='U' "$@"); then
    LoggerInfo 'Subindo container...'
    docker run $ENV_DOCKER_IMAGE_NAME &> ./../$ENV_INSTANCE_NAME.log &
  fi
fi

cd $_WHERE_AIM