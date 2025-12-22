#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating WordPress deployment..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:php8.2-apache
        command: ["/bin/sh", "-c", "while true; do echo 'WordPress running...' >> /var/log/wordpress.log; sleep 5; done"]
        ports:
        - containerPort: 80
YAML

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=Available deployment/wordpress --timeout=120s || true

echo "✅ Lab ready!"
echo "   - Deployment: wordpress"
echo "   - Task: Add sidecar container"
