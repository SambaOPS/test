#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace autoscale..."
kubectl create namespace autoscale

echo "🔹 Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system \
  --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' || true

echo "🔹 Creating Apache deployment..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: autoscale
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
          limits:
            cpu: 200m
YAML

echo "🔹 Exposing deployment..."
kubectl expose deployment apache-deployment -n autoscale --port=80 --target-port=80

echo "⏳ Waiting for metrics-server..."
kubectl rollout status deployment metrics-server -n kube-system --timeout=120s || true

echo "✅ Lab ready!"
echo "   - Namespace: autoscale"
echo "   - Deployment: apache-deployment"
echo "   - Task: Create HPA"
