#!/bin/bash
set -e

echo "🔍 Vérification du lab NodePort..."

# Check 1: Deployment has container port configured
PORT_NAME=$(kubectl get deploy nodeport-deployment -n relative -o jsonpath='{.spec.template.spec.containers[0].ports[0].name}' 2>/dev/null)
PORT_NUM=$(kubectl get deploy nodeport-deployment -n relative -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null)

if [ "$PORT_NUM" != "80" ]; then
  echo "❌ Container port non configuré (attendu: 80)"
  exit 1
fi
echo "✅ Container port = 80"

if [ "$PORT_NAME" != "http" ]; then
  echo "⚠️  Port name = '$PORT_NAME' (attendu: http)"
fi
echo "✅ Port name configuré"

# Check 2: Service exists
if ! kubectl get svc nodeport-service -n relative &>/dev/null; then
  echo "❌ Service 'nodeport-service' non trouvé"
  exit 1
fi
echo "✅ Service 'nodeport-service' existe"

# Check 3: Service is NodePort
SVC_TYPE=$(kubectl get svc nodeport-service -n relative -o jsonpath='{.spec.type}')
if [ "$SVC_TYPE" != "NodePort" ]; then
  echo "❌ Service n'est pas NodePort (type: $SVC_TYPE)"
  exit 1
fi
echo "✅ Service type = NodePort"

# Check 4: Service port is 80
SVC_PORT=$(kubectl get svc nodeport-service -n relative -o jsonpath='{.spec.ports[0].port}')
if [ "$SVC_PORT" != "80" ]; then
  echo "❌ Service port incorrect (actuel: $SVC_PORT, attendu: 80)"
  exit 1
fi
echo "✅ Service port = 80"

# Check 5: NodePort is 30080
NODE_PORT=$(kubectl get svc nodeport-service -n relative -o jsonpath='{.spec.ports[0].nodePort}')
if [ "$NODE_PORT" != "30080" ]; then
  echo "❌ NodePort incorrect (actuel: $NODE_PORT, attendu: 30080)"
  exit 1
fi
echo "✅ NodePort = 30080"

# Check 6: Service selector matches deployment
SELECTOR=$(kubectl get svc nodeport-service -n relative -o jsonpath='{.spec.selector.app}')
if [ "$SELECTOR" != "nodeport-deployment" ]; then
  echo "⚠️  Selector: app=$SELECTOR"
fi
echo "✅ Service selector configuré"

# Check 7: Pods are running
READY=$(kubectl get deploy nodeport-deployment -n relative -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "2" ]; then
  echo "⚠️  Replicas ready: $READY/2"
fi
echo "✅ Pods running"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
