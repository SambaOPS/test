#!/bin/bash
set -e
kubectl create namespace priority --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<YAML
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: user-critical
value: 1000
globalDefault: false
description: "Highest user-defined priority class"
YAML

kubectl apply -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
  namespace: priority
spec:
  replicas: 1
  selector:
    matchLabels:
      app: busybox-logger
  template:
    metadata:
      labels:
        app: busybox-logger
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["sh", "-c", "while true; do echo 'logging...'; sleep 5; done"]
YAML
echo "✅ Lab ready!"
