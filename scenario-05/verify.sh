#!/bin/bash
set -e

echo "🔍 Vérification du lab HPA..."

# Check 1: HPA exists
if ! kubectl get hpa apache-server -n autoscale &>/dev/null; then
  echo "❌ HPA 'apache-server' non trouvé dans namespace 'autoscale'"
  exit 1
fi
echo "✅ HPA 'apache-server' existe"

# Check 2: Target deployment
TARGET=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.scaleTargetRef.name}')
if [ "$TARGET" != "apache-deployment" ]; then
  echo "❌ HPA ne cible pas 'apache-deployment' (cible: $TARGET)"
  exit 1
fi
echo "✅ HPA cible 'apache-deployment'"

# Check 3: Min replicas
MIN=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.minReplicas}')
if [ "$MIN" != "1" ]; then
  echo "❌ minReplicas incorrect (actuel: $MIN, attendu: 1)"
  exit 1
fi
echo "✅ minReplicas = 1"

# Check 4: Max replicas
MAX=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.maxReplicas}')
if [ "$MAX" != "4" ]; then
  echo "❌ maxReplicas incorrect (actuel: $MAX, attendu: 4)"
  exit 1
fi
echo "✅ maxReplicas = 4"

# Check 5: CPU target 50%
CPU_TARGET=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')
if [ "$CPU_TARGET" != "50" ]; then
  echo "❌ CPU target incorrect (actuel: $CPU_TARGET%, attendu: 50%)"
  exit 1
fi
echo "✅ CPU target = 50%"

# Check 6: Stabilization window
STABILIZATION=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}')
if [ "$STABILIZATION" != "30" ]; then
  echo "❌ Stabilization window incorrect (actuel: ${STABILIZATION}s, attendu: 30s)"
  exit 1
fi
echo "✅ Downscale stabilization = 30s"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
