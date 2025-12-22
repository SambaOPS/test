#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace relative..."
kubectl create namespace relative

echo "🔹 Creating nodeport-deployment..."
kubectl -n relative create deployment nodeport-deployment --image=nginx --replicas=2

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=Available deployment/nodeport-deployment -n relative --timeout=120s || true

echo "✅ Lab ready!"
echo "   - Namespace: relative"
echo "   - Deployment: nodeport-deployment (no ports defined)"
echo "   - Task: Configure ports and create NodePort Service"
