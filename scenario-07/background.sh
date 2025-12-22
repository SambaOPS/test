#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace priority..."
kubectl create namespace priority

echo "🔹 Creating existing PriorityClass user-critical..."
cat <<YAML | kubectl apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: user-critical
value: 1000
globalDefault: false
description: "Highest user-defined priority class"
YAML

echo "🔹 Creating busybox-logger deployment..."
cat <<YAML | kubectl apply -f -
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

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=Available deployment/busybox-logger -n priority --timeout=60s || true

echo "✅ Lab ready!"
echo "   - PriorityClass: user-critical (value=1000)"
echo "   - Deployment: busybox-logger in priority namespace"
