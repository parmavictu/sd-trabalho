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

#
# Monitoração
#
if $(HasFlag --value='monitoring' --upper-flag='M' "$@"); then
    if $(HasFlag --value='create' --upper-flag='C' "$@"); then
        if [[ $(kubectl get ns | grep monitoring | wc -l) -gt 0 ]]; then
            kubectl delete namespace monitoring
        fi
        kubectl create namespace monitoring

        kubectl create -f monitoring/k8s/grafana
        kubectl create -f monitoring/k8s/prometheus
        kubectl create -f monitoring/k8s/kube-state-metrics
    elif $(HasFlag --value='delete' --upper-flag='D' "$@"); then
        if [[ $(kubectl get ns | grep monitoring | wc -l) -gt 0 ]]; then
            kubectl delete namespace monitoring
        fi
        kubectl delete -f monitoring/k8s
    elif $(HasFlag --value='apply' --upper-flag='A' "$@"); then
        if [[ ! $(kubectl get ns | grep monitoring | wc -l) -gt 0 ]]; then
            exit 1
        fi
        kubectl apply -f monitoring/k8s/grafana
        kubectl apply -f monitoring/k8s/prometheus
    fi
    exit 1
fi

#
# Aplicações Backend
#
if $(HasFlag --value='create' --upper-flag='C' "$@"); then
    Create ./${BACKEND_API_NODE}/k8s
    Create ./${GATEWAY}/k8s
    Create ./${BACKEND_API_GO}/k8s
elif $(HasFlag --value='delete' --upper-flag='D' "$@"); then
    Delete ./${BACKEND_API_NODE}/k8s
    Delete ./${GATEWAY}/k8s
    Delete ./${BACKEND_API_GO}/k8s
elif $(HasFlag --value='apply' --upper-flag='A' "$@"); then
    Apply ./${BACKEND_API_NODE}/k8s
    Apply ./${GATEWAY}/k8s
    Apply ./${BACKEND_API_GO}/k8s
elif $(HasFlag --value='clear' --upper-flag='CL' "$@"); then
    minikube delete
else
    LoggerError "Flag inválida!"
    echo -e '\n\nUse: build.k8s.sh [OPTIONS]\n'
    echo '--build, B        -   Buildar imagens das api através do docker-compose.yaml.'
    echo '--create, C       -   Crie um novo deployment.'
    echo '--delete, D       -   Delete um deployment existem.'
    echo '--apply, D        -   Aplicar a um deployment existem.'
    echo '--monitoring, M   -   Ativar monitoramento com (Prometeus e Grafana).'
    echo -e '\nExemplos:'
    echo -e '\t$ ./build.k8s.sh --create'
    echo -e '\t$ ./build.k8s.sh --delete'
    echo -e '\t$ ./build.k8s.sh --apply'
    echo -e '\n\nExemplo ativar monitoramento:'
    echo -e '\t$ ./build.k8s.sh --monitoring --create'
    echo -e '\n\n'
fi

cd $_WHERE_AIM