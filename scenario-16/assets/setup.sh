#!/bin/bash
set -e
kubectl create namespace relative || true
kubectl -n relative create deployment nodeport-deployment --image=nginx --replicas=2
echo "Lab ready!"
