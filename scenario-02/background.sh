#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Installing Helm if needed..."
if ! command -v helm &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "✅ Lab ready - No additional setup needed"
