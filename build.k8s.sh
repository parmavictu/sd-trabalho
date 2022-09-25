#!/bin/bash
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'build.k8s.sh' | grep -Po '(?<=-> ).*(?=/build.k8s.sh)' | sed 's/ //g'))

_WHERE_AIM=$(pwd)

cd $_ROOT_PATH

# Carrega funcoes em Bash.
source sh/utils.sh

# Carrega ENV's com caminho dos fontes.
source .env

StartMinikube

if $(HasFlag --value='build' --upper-flag='B' "$@"); then
    eval $(minikube docker-env)

    docker rmi $(docker images | grep 'none' | awk '{print $3}') &> /dev/null
    docker rmi -f $(docker images | grep trabalho-sd | awk '{print $3}') &> /dev/null

    docker-compose build --no-cache

    eval $(minikube docker-env -u)
fi

if $(HasFlag --value='create' --upper-flag='C' "$@"); then
#   BACKEND_API_NODE=backend-nodejs
#   BACKEND_API_GO=backend-go
#   GATEWAY=gateway
    Create ./${BACKEND_API_NODE}/k8s
    Create ./${GATEWAY}/k8s
elif $(HasFlag --value='delete' --upper-flag='D' "$@"); then
    Delete ./${BACKEND_API_NODE}/k8s
    Delete ./${GATEWAY}/k8s
elif $(HasFlag --value='apply' --upper-flag='A' "$@"); then
    Apply ./${BACKEND_API_NODE}/k8s
    Apply ./${GATEWAY}/k8s
else
    LoggerError "Flag inválida!"
    echo -e '\n\nUse: build.k8s.sh [OPTIONS]'
    echo '--build, B        -   Buildar imagens das api através do docker-compose.yaml.'
    echo '--create, C       -   Crie um novo deployment.'
    echo '--delete, D       -   Delete um deployment existem.'
    echo '--apply, D        -   Aplicar a um deployment existem.'
    echo -e '\nExemplos:'
    echo -e '\t$ ./build.k8s.sh --create'
    echo -e '\t$ ./build.k8s.sh --delete'
    echo -e '\t$ ./build.k8s.sh --apply'
    echo -e '\n\n'
fi

cd $_WHERE_AIM