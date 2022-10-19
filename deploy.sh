#!/bin/bash
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'deploy.sh' | grep -Po '(?<=-> ).*(?=/deploy.sh)' | sed 's/ //g'))

_WHERE_AIM=$(pwd)

function Help() {
    echo -e '\n\nUse: deploy.sh [OPTIONS]\n'
    echo '--build, B        -   Buildar imagens das api através do docker-compose.yaml.'
    echo '--create, C       -   Crie um novo deployment.'
    echo '--delete, D       -   Delete um deployment existem.'
    echo '--apply, D        -   Aplicar a um deployment existem.'
    echo '--monitoring, M   -   Ativar monitoramento com (Prometeus e Grafana).'
    echo -e '\nExemplos:'
    echo -e '\n\nDeploy gateway:'
    echo -e '\t$ ./deploy.sh --gateway --build --create'
    echo -e '\t$ ./deploy.sh --gateway --delete'
    echo -e '\t$ ./deploy.sh --gateway --apply'
    echo -e '\n\nDeploy backend:'
    echo -e '\t$ ./deploy.sh --backend --build --create'
    echo -e '\t$ ./deploy.sh --backend --delete'
    echo -e '\t$ ./deploy.sh --backend --apply'
    echo -e '\n\nExemplo ativar monitoramento:'
    echo -e '\t$ ./deploy.sh --monitoring --create'
    echo -e '\n\n'
}

cd $_ROOT_PATH

# Carrega funcoes em Bash.
source sh/utils.sh

# Carrega ENV's com caminho dos fontes.
source .env

if $(HasFlag --value='help' --upper-flag='H' "$@"); then
    Help
    exit 1
fi

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
    if $(HasFlag --value='gateway' --upper-flag='GT' "$@") || $(HasFlag --value='all' --upper-flag='L' "$@"); then
        kubectl create -f ./${GATEWAY}/k8s
    elif $(HasFlag --value='backend' --upper-flag='BK' "$@") || $(HasFlag --value='all' --upper-flag='L' "$@"); then
        kubectl create -f ./${BACKEND_API_GO}/k8s
    fi
elif $(HasFlag --value='delete' --upper-flag='D' "$@"); then
    if $(HasFlag --value='gateway' --upper-flag='GT' "$@") || $(HasFlag --value='all' --upper-flag='L' "$@"); then
        kubectl delete -f ./${GATEWAY}/k8s
    elif $(HasFlag --value='backend' --upper-flag='BK' "$@") || $(HasFlag --value='all' --upper-flag='L' "$@"); then
        kubectl delete -f ./${BACKEND_API_GO}/k8s
    fi
elif $(HasFlag --value='apply' --upper-flag='A' "$@"); then
    if $(HasFlag --value='gateway' --upper-flag='GT' "$@") || $(HasFlag --value='all' --upper-flag='L' "$@"); then
        kubectl apply -f ./${GATEWAY}/k8s
    elif $(HasFlag --value='backend' --upper-flag='BK' "$@") || $(HasFlag --value='all' --upper-flag='L' "$@"); then
        kubectl apply -f ./${BACKEND_API_GO}/k8s
    fi

elif $(HasFlag --value='clear' --upper-flag='CL' "$@"); then
    minikube delete
else
    LoggerError "Flag inválida!"
    Help
fi

cd $_WHERE_AIM