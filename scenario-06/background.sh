#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace cert-manager..."
kubectl create ns cert-manager

echo "🔹 Installing cert-manager CRDs..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml

echo "⏳ Waiting for CRDs to be established..."
sleep 5
kubectl wait --for=condition=Established crd/certificates.cert-manager.io --timeout=60s || true

echo "✅ Lab ready!"
echo "   - Namespace: cert-manager"
echo "   - CRDs: cert-manager installed"
echo "   - Task: List CRDs and extract documentation"
