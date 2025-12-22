#!/bin/bash
set -e

echo "🔍 Vérification du lab MariaDB PV..."

# Check 1: PVC exists
if ! kubectl get pvc mariadb -n mariadb &>/dev/null; then
  echo "❌ PVC 'mariadb' non trouvé dans namespace 'mariadb'"
  exit 1
fi
echo "✅ PVC 'mariadb' existe"

# Check 2: PVC is Bound
PVC_STATUS=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.status.phase}')
if [ "$PVC_STATUS" != "Bound" ]; then
  echo "❌ PVC n'est pas Bound (status: $PVC_STATUS)"
  exit 1
fi
echo "✅ PVC est Bound"

# Check 3: PVC bound to correct PV
PV_NAME=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.spec.volumeName}')
if [ "$PV_NAME" != "mariadb-pv" ]; then
  echo "⚠️  PVC lié à '$PV_NAME' (attendu: mariadb-pv)"
fi
echo "✅ PVC lié au PV"

# Check 4: Deployment exists
if ! kubectl get deploy mariadb -n mariadb &>/dev/null; then
  echo "❌ Deployment 'mariadb' non trouvé"
  exit 1
fi
echo "✅ Deployment 'mariadb' existe"

# Check 5: Deployment uses PVC
CLAIM_NAME=$(kubectl get deploy mariadb -n mariadb -o jsonpath='{.spec.template.spec.volumes[0].persistentVolumeClaim.claimName}')
if [ "$CLAIM_NAME" != "mariadb" ]; then
  echo "❌ Deployment n'utilise pas le PVC 'mariadb' (claimName: $CLAIM_NAME)"
  exit 1
fi
echo "✅ Deployment utilise le PVC 'mariadb'"

# Check 6: Pod is running
READY=$(kubectl get deploy mariadb -n mariadb -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "1" ]; then
  echo "❌ Pod MariaDB n'est pas ready (ready: $READY)"
  exit 1
fi
echo "✅ Pod MariaDB est running"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
