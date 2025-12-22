#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done

echo "✅ Lab ready!"
echo "   - Cluster is ready"
echo "   - Task: Install CNI (Calico or Flannel)"
echo ""
echo "Note: Choose Calico for NetworkPolicy support"
