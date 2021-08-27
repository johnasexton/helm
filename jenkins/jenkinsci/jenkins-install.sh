#!/usr/local/bin/bash
export GCPPROJECT="initialkubetest"
export GKECLUSTER="gke_initialkubetest_us-east1-b_initialkubetest-e1-01"
export REPOSPACE="jenkinsci" # jenkinsci or bitnami
export NAMESPACE="jenkins"

# dynamic from "${REPOSPACE}/${NAMESPACE}"
# export CHART="${REPOSPACE}/${NAMESPACE}"
# export CHARTSLOCALE="bitnami https://charts.bitnami.com/bitnami"
# export CHARTSLOCALE="jenkinsci https://charts.jenkins.io"

# local bitnami charts & values
# export CHART="/Users/johnsexton/workspace/bitnami/charts/bitnami/jenkins"
# export VALUESFILE="/Users/johnsexton/workspace/bitnami/charts/bitnami/jenkins/values.yaml"

# local jenkinsci charts & values
export CHART="/Users/johnsexton/workspace/jenkinsci/helm-charts/charts/jenkins"
# export VALUESFILE="/Users/johnsexton/workspace/jenkinsci/helm-charts/charts/jenkins/values.yaml"

# local helm/stable charts & values
# export CHART="/Users/johnsexton/workspace/helm/charts/stable/jenkins"
# export VALUESFILE="/Users/johnsexton/workspace/helm/charts/stable/jenkins/values.yaml"

export VALUESFILE="jenkins-values.yaml"
export GKENAMESPACE="jenkins"
export DEPLOYMENTNAME="jenkins"

# set context
echo "gcloud config set project ${GCPPROJECT}"
gcloud config set project ${GCPPROJECT}
echo "kubectx ${GKECLUSTER}"
kubectx ${GKECLUSTER}

# create namespace
echo "kubectl create namespace ${GKENAMESPACE}"
kubectl create namespace ${GKENAMESPACE}
echo "kubectl get namespaces"
kubectl get namespaces

# add helm repos
# helm repo add ${CHARTSLOCALE}
echo "helm repo update"
helm repo update
# echo "helm search repo ${REPOSPACE}"
# helm search repo ${REPOSPACE}

# apply manifests & edit helm values
# volume only needed for rue gke but not autopilot gke
echo "kubectl apply -f jenkins-volume.yaml"
kubectl apply -f jenkins-volume.yaml
echo "kubectl apply -f jenkins-sa.yaml"
kubectl apply -f jenkins-sa.yaml

# install jenkins via helm deployment
echo "helm install ${DEPLOYMENTNAME} -n ${GKENAMESPACE} -f ${VALUESFILE} ${CHART}"
helm install ${DEPLOYMENTNAME} -n ${GKENAMESPACE} -f ${VALUESFILE} ${CHART}

# get admin password
# jsonpath="{.data.jenkins-admin-password}"
# secret=$(kubectl get secret -n jenkins jenkins -o jsonpath=$jsonpath)
# echo $(echo $secret | base64 --decode)

# get jenkins url
# jsonpath="{.spec.ports[0].nodePort}"
# NODE_PORT=$(kubectl get -n jenkins -o jsonpath=$jsonpath services jenkins)
# jsonpath="{.items[0].status.addresses[0].address}"
# NODE_IP=$(kubectl get nodes -n jenkins -o jsonpath=$jsonpath)
# echo "http://$NODE_IP:$NODE_PORT/login"

# show running pods
# kubectl get pods -n jenkins

# get admin password
# jsonpath="{.data.jenkins-admin-password}"
# secret=$(kubectl get secret -n jenkins jenkins -o jsonpath=$jsonpath)
# echo $(echo $secret | base64 --decode)

# OR alternate get admin password
# jsonpath="{.data.jenkins-admin-password}"
# kubectl get secret -n jenkins jenkins -o jsonpath=$jsonpath

# view status and connect to Jenkin's resources
# kubectl get pods -n jenkins
# kubectl get deployments -n jenkins

# display connection info
# echo "To create a local port forwarding tunnel run:
# kubectl -n jenkins port-forward <pod_name> 8080:8080
# and direct a browser to http://localhost:8080
# "
