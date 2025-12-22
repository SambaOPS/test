#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Checking existing StorageClasses..."
kubectl get sc

echo "✅ Lab ready!"
echo "   - Task: Create StorageClass local-storage"
echo "   - Task: Make it the default StorageClass"
