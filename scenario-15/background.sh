#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster to be ready first..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Backing up kube-apiserver manifest..."
cp /etc/kubernetes/manifests/kube-apiserver.yaml /root/kube-apiserver.yaml.bak

echo "🔹 Simulating ETCD migration issue..."
echo "   Changing etcd port from 2379 (client) to 2380 (peer)..."
sed -i 's/:2379/:2380/g' /etc/kubernetes/manifests/kube-apiserver.yaml

echo "⏳ Waiting for API server to fail..."
sleep 10

echo "✅ Lab ready!"
echo "   - kube-apiserver is now broken"
echo "   - Backup: /root/kube-apiserver.yaml.bak"
echo "   - Task: Fix the ETCD endpoint configuration"
echo ""
echo "⚠️  kubectl will not work until you fix the issue!"
