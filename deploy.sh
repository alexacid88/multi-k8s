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
kubectl set image deployments/server-deployment server=alexacid88/multi-server:$SHA
kubectl set image deployments/client-deployment client=alexacid88/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=alexacid88/multi-worker:$SHA
