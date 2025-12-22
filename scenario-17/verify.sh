#!/bin/bash
set -e

echo "🔍 Vérification du lab TLS Configuration..."

# Check 1: ConfigMap exists
if ! kubectl get cm nginx-config -n nginx-static &>/dev/null; then
  echo "❌ ConfigMap 'nginx-config' non trouvé"
  exit 1
fi
echo "✅ ConfigMap 'nginx-config' existe"

# Check 2: ConfigMap only has TLSv1.3
CM_CONTENT=$(kubectl get cm nginx-config -n nginx-static -o jsonpath='{.data.nginx\.conf}')

if echo "$CM_CONTENT" | grep -q "TLSv1.2"; then
  echo "❌ ConfigMap contient encore TLSv1.2"
  echo "   Trouvé: $(echo "$CM_CONTENT" | grep ssl_protocols)"
  exit 1
fi
echo "✅ TLSv1.2 supprimé de la configuration"

if ! echo "$CM_CONTENT" | grep -q "TLSv1.3"; then
  echo "❌ TLSv1.3 non trouvé dans la configuration"
  exit 1
fi
echo "✅ TLSv1.3 configuré"

# Check 3: /etc/hosts entry
if ! grep -q "ckaquestion.k8s.local" /etc/hosts; then
  echo "❌ Entrée 'ckaquestion.k8s.local' non trouvée dans /etc/hosts"
  exit 1
fi
echo "✅ /etc/hosts configuré avec ckaquestion.k8s.local"

# Check 4: Service exists
if ! kubectl get svc nginx-static -n nginx-static &>/dev/null; then
  echo "❌ Service 'nginx-static' non trouvé"
  exit 1
fi
echo "✅ Service 'nginx-static' existe"

# Check 5: Deployment is running
READY=$(kubectl get deploy nginx-static -n nginx-static -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$READY" != "1" ]; then
  echo "⚠️  Deployment pas ready - avez-vous fait 'kubectl rollout restart'?"
fi
echo "✅ Deployment nginx-static ready"

# Check 6: Test TLS (if curl available)
if command -v curl &>/dev/null; then
  echo ""
  echo "🧪 Test TLS..."
  
  # Get service IP
  SVC_IP=$(kubectl get svc nginx-static -n nginx-static -o jsonpath='{.spec.clusterIP}')
  
  # Test TLSv1.2 should fail
  if curl -sk --connect-timeout 3 --tls-max 1.2 "https://$SVC_IP" &>/dev/null; then
    echo "⚠️  TLSv1.2 semble encore fonctionner"
  else
    echo "✅ TLSv1.2 rejeté (attendu)"
  fi
  
  # Test TLSv1.3 should work
  if curl -sk --connect-timeout 3 --tlsv1.3 "https://$SVC_IP" &>/dev/null; then
    echo "✅ TLSv1.3 fonctionne"
  else
    echo "⚠️  TLSv1.3 ne répond pas (vérifiez le rollout)"
  fi
fi

echo ""
echo "🎉 Vérification terminée!"
exit 0
