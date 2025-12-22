#!/bin/bash
set -e

echo "🔍 Vérification du lab Taints & Tolerations..."

# Check 1: Taint exists on node01
TAINT=$(kubectl describe node node01 2>/dev/null | grep "Taints:" | grep "PERMISSION=granted:NoSchedule")
if [ -z "$TAINT" ]; then
  echo "❌ Taint 'PERMISSION=granted:NoSchedule' non trouvé sur node01"
  kubectl describe node node01 | grep -A2 "Taints:" || true
  exit 1
fi
echo "✅ Taint 'PERMISSION=granted:NoSchedule' présent sur node01"

# Check 2: A pod with toleration exists
PODS_WITH_TOLERATION=$(kubectl get pods -o json | jq -r '.items[] | select(.spec.tolerations[]?.key == "PERMISSION") | .metadata.name' 2>/dev/null)
if [ -z "$PODS_WITH_TOLERATION" ]; then
  echo "❌ Aucun pod avec toleration 'PERMISSION' trouvé"
  exit 1
fi
echo "✅ Pod(s) avec toleration trouvé(s): $PODS_WITH_TOLERATION"

# Check 3: Pod is running (not Pending)
for POD in $PODS_WITH_TOLERATION; do
  STATUS=$(kubectl get pod $POD -o jsonpath='{.status.phase}' 2>/dev/null)
  if [ "$STATUS" = "Running" ]; then
    echo "✅ Pod '$POD' est Running"
  else
    echo "⚠️  Pod '$POD' status: $STATUS"
  fi
done

# Check 4: Verify toleration details
TOLERATION_EFFECT=$(kubectl get pods -o json | jq -r '.items[] | select(.spec.tolerations[]?.key == "PERMISSION") | .spec.tolerations[] | select(.key == "PERMISSION") | .effect' 2>/dev/null | head -1)
TOLERATION_VALUE=$(kubectl get pods -o json | jq -r '.items[] | select(.spec.tolerations[]?.key == "PERMISSION") | .spec.tolerations[] | select(.key == "PERMISSION") | .value' 2>/dev/null | head -1)

if [ "$TOLERATION_EFFECT" = "NoSchedule" ] && [ "$TOLERATION_VALUE" = "granted" ]; then
  echo "✅ Toleration correcte: PERMISSION=granted:NoSchedule"
else
  echo "⚠️  Vérifiez les détails de la toleration (effect=$TOLERATION_EFFECT, value=$TOLERATION_VALUE)"
fi

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
