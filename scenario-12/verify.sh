#!/bin/bash
set -e

echo "🔍 Vérification du lab Ingress..."

# Check 1: Service exists
if ! kubectl get svc echo-service -n echo-sound &>/dev/null; then
  echo "❌ Service 'echo-service' non trouvé dans namespace 'echo-sound'"
  exit 1
fi
echo "✅ Service 'echo-service' existe"

# Check 2: Service is NodePort
SVC_TYPE=$(kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.type}')
if [ "$SVC_TYPE" != "NodePort" ]; then
  echo "❌ Service n'est pas de type NodePort (type: $SVC_TYPE)"
  exit 1
fi
echo "✅ Service type = NodePort"

# Check 3: Service port is 8080
SVC_PORT=$(kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.ports[0].port}')
if [ "$SVC_PORT" != "8080" ]; then
  echo "❌ Service port incorrect (actuel: $SVC_PORT, attendu: 8080)"
  exit 1
fi
echo "✅ Service port = 8080"

# Check 4: Ingress exists
if ! kubectl get ingress echo -n echo-sound &>/dev/null; then
  echo "❌ Ingress 'echo' non trouvé dans namespace 'echo-sound'"
  exit 1
fi
echo "✅ Ingress 'echo' existe"

# Check 5: Ingress host
ING_HOST=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].host}')
if [ "$ING_HOST" != "example.org" ]; then
  echo "❌ Ingress host incorrect (actuel: $ING_HOST, attendu: example.org)"
  exit 1
fi
echo "✅ Ingress host = example.org"

# Check 6: Ingress path
ING_PATH=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].path}')
if [ "$ING_PATH" != "/echo" ]; then
  echo "❌ Ingress path incorrect (actuel: $ING_PATH, attendu: /echo)"
  exit 1
fi
echo "✅ Ingress path = /echo"

# Check 7: Ingress backend
ING_BACKEND=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')
if [ "$ING_BACKEND" != "echo-service" ]; then
  echo "❌ Ingress backend incorrect (actuel: $ING_BACKEND)"
  exit 1
fi
echo "✅ Ingress backend = echo-service"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
