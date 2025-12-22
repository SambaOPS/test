#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace echo-sound..."
kubectl create ns echo-sound

echo "🔹 Creating Echo Server deployment..."
cat <<YAML | kubectl -n echo-sound apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: gcr.io/google_containers/echoserver:1.10
        ports:
        - containerPort: 8080
YAML

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=Available deployment/echo -n echo-sound --timeout=120s || true

echo "✅ Lab ready!"
echo "   - Namespace: echo-sound"
echo "   - Deployment: echo"
echo "   - Task: Create Service and Ingress"
