
# deploy an application and a service
# describe a namespace, deployment, and a service
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'deploy.sh' | grep -Po '(?<=-> ).*(?=/deploy.sh)' | sed 's/ //g'))
_WHERE_AIM=$(pwd)

cd $_ROOT_PATH
kubectl delete -f monitoring-namespace.yaml
kubectl create -f monitoring-namespace.yaml

sleep 5

kubectl create -f prometheus-config.yaml
kubectl create -f prometheus-deployment.yaml
kubectl create -f prometheus-service.yaml

# view via CLI:
kubectl get services --namespace=monitoring

kubectl get deployments --namespace=monitoring

# show the dashboard
minikube dashboard &

# click around
# show /targets

# show graph and query of container_memory_usage_bytes{kubernetes_namespace="monitoring"}

# deploy grafana
kubectl create -f grafana-deployment.yaml
kubectl create -f grafana-ingress.yaml

# show grafana
kubectl get services --namespace=monitoring
kubectl get deployments --namespace=monitoring

# add datasource. make sure type is prometheus http://prometheus:8080
# describe kubernetes DNS

# create a graph:
#  container_memory_usage_bytes{kubernetes_namespace="monitoring"}
# {{kubernetes_pod_name}

# lets add node metrics
# deploy node exporter. explain daemonser
kubectl create -f node-exporter-daemonset.yml

# show new target in prometheus. explain it autodiscovering the pods

# now create a graph

# node_load1
# {{kubernetes_pod_node_name}}

cd $_WHERE_AIM