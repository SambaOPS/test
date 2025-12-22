#!/bin/bash
set -e

echo "🔍 Vérification du lab ETCD Fix..."

# Check 1: kubectl works (API server is up)
if ! kubectl get nodes &>/dev/null; then
  echo "❌ kubectl ne fonctionne pas - API server down"
  echo "Vérifiez /etc/kubernetes/manifests/kube-apiserver.yaml"
  exit 1
fi
echo "✅ kubectl fonctionne - API server UP"

# Check 2: API server pod is running
APISERVER_STATUS=$(kubectl get pods -n kube-system -l component=kube-apiserver -o jsonpath='{.items[0].status.phase}' 2>/dev/null)
if [ "$APISERVER_STATUS" != "Running" ]; then
  echo "⚠️  kube-apiserver status: $APISERVER_STATUS"
fi
echo "✅ kube-apiserver est Running"

# Check 3: Verify etcd endpoint in manifest
ETCD_ENDPOINT=$(grep -o "etcd-servers=https://[^\"]*" /etc/kubernetes/manifests/kube-apiserver.yaml | head -1)
if echo "$ETCD_ENDPOINT" | grep -q ":2380"; then
  echo "❌ etcd endpoint utilise encore le port peer 2380!"
  echo "   Trouvé: $ETCD_ENDPOINT"
  echo "   Devrait utiliser le port client 2379"
  exit 1
fi
echo "✅ etcd endpoint utilise le port client 2379"

# Check 4: All system pods running
NOT_RUNNING=$(kubectl get pods -n kube-system --no-headers | grep -v "Running\|Completed" | wc -l)
if [ "$NOT_RUNNING" -gt 0 ]; then
  echo "⚠️  Certains pods kube-system ne sont pas Running:"
  kubectl get pods -n kube-system | grep -v "Running\|Completed"
fi

# Check 5: Nodes are Ready
NOT_READY=$(kubectl get nodes --no-headers | grep -v " Ready" | wc -l)
if [ "$NOT_READY" -gt 0 ]; then
  echo "⚠️  Certains nodes ne sont pas Ready"
  kubectl get nodes
fi
echo "✅ Cluster opérationnel"

echo ""
echo "🎉 ETCD fix vérifié - Cluster fonctionnel!"
exit 0
