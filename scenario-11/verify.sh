#!/bin/bash
set -e

echo "🔍 Vérification du lab Gateway API..."

# Check 1: Gateway exists
if ! kubectl get gateway web-gateway &>/dev/null; then
  echo "❌ Gateway 'web-gateway' non trouvé"
  exit 1
fi
echo "✅ Gateway 'web-gateway' existe"

# Check 2: Gateway uses correct GatewayClass
GW_CLASS=$(kubectl get gateway web-gateway -o jsonpath='{.spec.gatewayClassName}')
if [ "$GW_CLASS" != "nginx-class" ]; then
  echo "❌ Gateway n'utilise pas 'nginx-class' (actuel: $GW_CLASS)"
  exit 1
fi
echo "✅ Gateway utilise 'nginx-class'"

# Check 3: Gateway has correct hostname
GW_HOST=$(kubectl get gateway web-gateway -o jsonpath='{.spec.listeners[0].hostname}')
if [ "$GW_HOST" != "gateway.web.k8s.local" ]; then
  echo "❌ Hostname incorrect (actuel: $GW_HOST)"
  exit 1
fi
echo "✅ Gateway hostname = gateway.web.k8s.local"

# Check 4: Gateway has TLS configured
TLS_SECRET=$(kubectl get gateway web-gateway -o jsonpath='{.spec.listeners[0].tls.certificateRefs[0].name}')
if [ "$TLS_SECRET" != "web-tls" ]; then
  echo "❌ TLS secret incorrect (actuel: $TLS_SECRET, attendu: web-tls)"
  exit 1
fi
echo "✅ TLS configuré avec secret 'web-tls'"

# Check 5: HTTPRoute exists
if ! kubectl get httproute web-route &>/dev/null; then
  echo "❌ HTTPRoute 'web-route' non trouvé"
  exit 1
fi
echo "✅ HTTPRoute 'web-route' existe"

# Check 6: HTTPRoute references Gateway
PARENT=$(kubectl get httproute web-route -o jsonpath='{.spec.parentRefs[0].name}')
if [ "$PARENT" != "web-gateway" ]; then
  echo "❌ HTTPRoute ne référence pas 'web-gateway' (parent: $PARENT)"
  exit 1
fi
echo "✅ HTTPRoute référence 'web-gateway'"

# Check 7: HTTPRoute has correct backend
BACKEND=$(kubectl get httproute web-route -o jsonpath='{.spec.rules[0].backendRefs[0].name}')
if [ "$BACKEND" != "web-service" ]; then
  echo "❌ Backend incorrect (actuel: $BACKEND, attendu: web-service)"
  exit 1
fi
echo "✅ HTTPRoute backend = 'web-service'"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
