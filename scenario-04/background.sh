#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating WordPress deployment with init container..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox
        command: ["sh", "-c", "echo 'Preparing...' && sleep 5"]
      containers:
      - name: wordpress
        image: wordpress:6.2-apache
        ports:
        - containerPort: 80
YAML

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=Available deployment/wordpress --timeout=180s || true

echo "✅ Lab ready!"
echo "   - Deployment: wordpress (3 replicas)"
echo "   - Task: Configure resource requests/limits"
