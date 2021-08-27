#!/usr/local/bin/bash
export USERNAME="user"
# export PASSWORD=`kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo`
export PASSWORD=`kubectl get secret/jenkins --namespace jenkins -o json -o jsonpath="{.data.jenkins-password}" | base64 --decode`
export SERVICE_URL=`export SERVICE_IP=$(kubectl get svc --namespace jenkins jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")`
export SERVICES=`kubectl get svc --namespace jenkins`

# get service URL public and private
echo "

SERVICES:

${SERVICES}

"

# get admin password
echo "LOGIN INFO:"
echo "USERNAME: ${USERNAME}"
echo "PASSWORD: ${PASSWORD}"
echo "SERVICE_URL: http://$SERVICE_IP:8080/login

"
