#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=180s

echo "🔹 Verifying node01 exists..."
kubectl get node node01 || echo "⚠️  node01 not found - check cluster"

echo "✅ Lab ready!"
echo "   - Nodes: controlplane, node01"
echo "   - Task: Add taint to node01, create pod with toleration"
