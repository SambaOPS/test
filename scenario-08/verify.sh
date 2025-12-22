#!/bin/bash
set -e

echo "🔍 Vérification du lab CNI..."

# Check for Calico
CALICO_PODS=$(kubectl get pods -n tigera-operator 2>/dev/null | grep -c Running || echo 0)
CALICO_SYSTEM=$(kubectl get pods -n calico-system 2>/dev/null | grep -c Running || echo 0)

# Check for Flannel
FLANNEL_PODS=$(kubectl get pods -n kube-flannel 2>/dev/null | grep -c Running || echo 0)
FLANNEL_SYSTEM=$(kubectl get pods -n kube-system 2>/dev/null | grep -c "flannel" || echo 0)

if [ "$CALICO_PODS" -gt 0 ] || [ "$CALICO_SYSTEM" -gt 0 ]; then
  echo "✅ Calico CNI détecté et running"
  echo "✅ Support NetworkPolicy: OUI"
  CNI_INSTALLED="calico"
elif [ "$FLANNEL_PODS" -gt 0 ] || [ "$FLANNEL_SYSTEM" -gt 0 ]; then
  echo "✅ Flannel CNI détecté et running"
  echo "⚠️  Support NetworkPolicy: NON (Flannel seul ne supporte pas NetworkPolicy)"
  CNI_INSTALLED="flannel"
else
  echo "❌ Aucun CNI détecté (ni Calico ni Flannel)"
  exit 1
fi

# Check if nodes are Ready
NOT_READY=$(kubectl get nodes --no-headers | grep -v "Ready" | wc -l)
if [ "$NOT_READY" -gt 0 ]; then
  echo "⚠️  Certains nodes ne sont pas Ready"
fi

# Check if pods can be scheduled
kubectl run test-cni --image=busybox --restart=Never --command -- sleep 5 &>/dev/null || true
sleep 3
POD_STATUS=$(kubectl get pod test-cni -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")
kubectl delete pod test-cni --ignore-not-found &>/dev/null

if [ "$POD_STATUS" = "Running" ] || [ "$POD_STATUS" = "Succeeded" ]; then
  echo "✅ Pods peuvent être schedulés"
else
  echo "⚠️  Test pod status: $POD_STATUS"
fi

echo ""
echo "🎉 CNI installé: $CNI_INSTALLED"
exit 0
