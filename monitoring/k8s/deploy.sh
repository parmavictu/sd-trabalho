
# deploy an application and a service
# describe a namespace, deployment, and a service
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'deploy.sh' | grep -Po '(?<=-> ).*(?=/deploy.sh)' | sed 's/ //g'))
_WHERE_AIM=$(pwd)

cd $_ROOT_PATH
source ./../../sh/utils.sh
source ./../../environment/k8s/.custom.env

LoggerInfo 'Iniciando monitoramento...'

kubectl delete -f monitoring-namespace.yaml
kubectl create -f monitoring-namespace.yaml

sleep 5

LoggerInfo 'Realizando deploy: prometheus'
kubectl create -f prometheus-config.yaml
kubectl create -f prometheus-deployment.yaml
kubectl create -f prometheus-service.yaml

# view via CLI:
LoggerInfo 'Verificando services...'
kubectl get services --namespace=monitoring

LoggerInfo 'Verificando deployments...'
kubectl get deployments --namespace=monitoring

# show the dashboard
LoggerInfo 'Abrindo dashboard...'
minikube dashboard &

# click around
# show /targets

# show graph and query of container_memory_usage_bytes{kubernetes_namespace="monitoring"}

# deploy grafana
LoggerInfo 'Realizando deploy: grafana'
kubectl create -f grafana-deployment.yaml
kubectl create -f grafana-ingress.yaml

# show grafana
LoggerInfo 'Verificando services...'
kubectl get services --namespace=monitoring

LoggerInfo 'Verificando deployments...'
kubectl get deployments --namespace=monitoring

# add datasource. make sure type is prometheus http://prometheus:8080
# describe kubernetes DNS

# create a graph:
#  container_memory_usage_bytes{kubernetes_namespace="monitoring"}
# {{kubernetes_pod_name}

# lets add node metrics
# deploy node exporter. explain daemonser
LoggerInfo 'Realizando deploy: node-exporter'
kubectl create -f node-exporter-daemonset.yml

# show new target in prometheus. explain it autodiscovering the pods

# now create a graph

# node_load1
# {{kubernetes_pod_node_name}}

cd $_WHERE_AIM