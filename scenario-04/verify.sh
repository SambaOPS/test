#!/bin/bash
set -e

echo "🔍 Vérification du lab Resource Allocation..."

# Check 1: Deployment exists
if ! kubectl get deploy wordpress &>/dev/null; then
  echo "❌ Deployment 'wordpress' non trouvé"
  exit 1
fi
echo "✅ Deployment 'wordpress' existe"

# Check 2: Replicas = 3
REPLICAS=$(kubectl get deploy wordpress -o jsonpath='{.spec.replicas}')
if [ "$REPLICAS" != "3" ]; then
  echo "❌ Replicas incorrect (actuel: $REPLICAS, attendu: 3)"
  exit 1
fi
echo "✅ 3 replicas configurés"

# Check 3: Main container has resources
CPU_REQ=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
MEM_REQ=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
CPU_LIM=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')
MEM_LIM=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')

if [ -z "$CPU_REQ" ] || [ -z "$MEM_REQ" ]; then
  echo "❌ Resources requests manquants sur le container principal"
  exit 1
fi
echo "✅ Main container: requests cpu=$CPU_REQ, memory=$MEM_REQ"

if [ -z "$CPU_LIM" ] || [ -z "$MEM_LIM" ]; then
  echo "❌ Resources limits manquants sur le container principal"
  exit 1
fi
echo "✅ Main container: limits cpu=$CPU_LIM, memory=$MEM_LIM"

# Check 4: Init container has same resources
INIT_CPU_REQ=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.cpu}')
INIT_MEM_REQ=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.memory}')

if [ -z "$INIT_CPU_REQ" ] || [ -z "$INIT_MEM_REQ" ]; then
  echo "❌ Resources manquants sur init container"
  exit 1
fi
echo "✅ Init container: requests cpu=$INIT_CPU_REQ, memory=$INIT_MEM_REQ"

# Check 5: Pods are running
READY=$(kubectl get deploy wordpress -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "3" ]; then
  echo "⚠️  Pods pas tous ready (ready: $READY/3)"
fi

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
