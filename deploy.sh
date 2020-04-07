#!/bin/bash

docker build -t alexacid88/multi-client:latest -t alexacid88/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t alexacid88/multi-server:latest -t alexacid88/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t alexacid88/multi-worker:latest -t alexacid88/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push alexacid88/multi-client:latest
docker push alexacid88/multi-server:latest
docker push alexacid88/multi-worker:latest

docker push alexacid88/multi-client:$SHA
docker push alexacid88/multi-server:$SHA
docker push alexacid88/multi-worker:$SHA

kubectl apply -f k8s
# It applies certmanager
# kubectl apply -f k8s-cert
kubectl set image deployments/server-deployment server=alexacid88/multi-server:$SHA
kubectl set image deployments/client-deployment client=alexacid88/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=alexacid88/multi-worker:$SHA

###########################
# TO RUN IN GCP - CONSOLE #
###########################
#
#SET UP POSTGRES PASSWORD
#kubectl create secret generic pgpassword --from-literal PGPASSWORD=
#
#INSTALL HELM 3
#kubectl create serviceaccount --namespace kube-system tiller
#kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
#curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
#chmod 700 get_helm.sh
#./get_helm.sh
#
#INSTALL KUBERNETES/INGRESS-NGINX
#helm repo add stable https://kubernetes-charts.storage.googleapis.com/
#helm repo update
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
#helm install my-nginx stable/nginx-ingress
