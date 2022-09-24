#!/bin/bash

_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'deploy.sh' | grep -Po '(?<=-> ).*(?=/deploy.sh)' | sed 's/ //g'))
_WHERE_AIM=$(pwd)

ENV_IMAGE_PULL_POLICY='Always'

echo "_ROOT_PATH: $_ROOT_PATH"

cd $_ROOT_PATH

source ./../sh/utils.sh

if $(HasFlag --value='build' "$@"); then
  ./docker/start-compose.sh "$@"
fi

cp ./src/config/environment/.prod.env ./docker/.env

source ./docker/.env

while IFS= read -r ENVS
do
  if [[ ! -z $(echo $ENVS | egrep '^#(.*)') ]] || [[ -z $ENVS ]]; then
    continue
  fi
  eval "echo $ENVS"
done < "./docker/.env"
echo -e '\n\n'

StartMinikube

if $(HasFlag --value='clear' "$@"); then
  LoggerInfo 'Limpando containers...'
  Delete ./k8s/deployment.yaml
  
fi

if ! $(HasFlag --value='k8s' --upper-flag='K' "$@"); then
  exit 1
fi

if $(HasFlag --value='force' --upper-flag='F' "$@"); then
  ENV_IMAGE_PULL_POLICY='Always'
fi

if [[ $(kubectl get po | grep $ENV_INSTANCE_NAME | wc -l) -gt 0 ]]; then
    echo -e "\n\n"
    LoggerInfo 'Aplicando mudanças...'
    Apply ./k8s/deployment.yaml
else
  LoggerInfo 'Criando instancias...'
  Create ./k8s/deployment.yaml
fi

while [[ $(kubectl get po  | grep $ENV_INSTANCE_NAME | grep -i 'running' | wc -l) -lt 2 ]]; do
    echo -ne "Aguardando... \033[0K\r"
done

rm ./docker/.env &> /dev/null

cd $_WHERE_AIM