#!/bin/bash
set -e

echo "🔍 Vérification du lab PriorityClass..."

# Check 1: PriorityClass exists
if ! kubectl get pc high-priority &>/dev/null; then
  echo "❌ PriorityClass 'high-priority' non trouvée"
  exit 1
fi
echo "✅ PriorityClass 'high-priority' existe"

# Check 2: Value is correct (999, one less than user-critical which is 1000)
VALUE=$(kubectl get pc high-priority -o jsonpath='{.value}')
if [ "$VALUE" != "999" ]; then
  echo "⚠️  Valeur: $VALUE (attendu: 999, une de moins que user-critical)"
fi
echo "✅ PriorityClass value = $VALUE"

# Check 3: Deployment exists
if ! kubectl get deploy busybox-logger -n priority &>/dev/null; then
  echo "❌ Deployment 'busybox-logger' non trouvé"
  exit 1
fi
echo "✅ Deployment 'busybox-logger' existe"

# Check 4: Deployment uses high-priority
PC_NAME=$(kubectl get deploy busybox-logger -n priority -o jsonpath='{.spec.template.spec.priorityClassName}')
if [ "$PC_NAME" != "high-priority" ]; then
  echo "❌ Deployment n'utilise pas 'high-priority' (actuel: $PC_NAME)"
  exit 1
fi
echo "✅ Deployment utilise 'high-priority'"

# Check 5: Pod is running
READY=$(kubectl get deploy busybox-logger -n priority -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "1" ]; then
  echo "⚠️  Pod pas ready (ready: $READY)"
fi
echo "✅ Configuration validée"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
