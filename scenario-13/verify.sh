#!/bin/bash
set -e

echo "🔍 Vérification du lab Network Policy..."

# Check 1: NetworkPolicy applied
NP_COUNT=$(kubectl get networkpolicy -n backend --no-headers 2>/dev/null | wc -l)
if [ "$NP_COUNT" -eq 0 ]; then
  echo "❌ Aucune NetworkPolicy trouvée dans namespace 'backend'"
  exit 1
fi
echo "✅ NetworkPolicy trouvée dans 'backend'"

# Check 2: Correct policy applied (policy-z is least permissive)
if kubectl get networkpolicy policy-z -n backend &>/dev/null; then
  echo "✅ NetworkPolicy 'policy-z' appliquée (la moins permissive)"
elif kubectl get networkpolicy policy-y -n backend &>/dev/null; then
  echo "⚠️  NetworkPolicy 'policy-y' appliquée - trop permissive (autorise ipBlock)"
elif kubectl get networkpolicy policy-x -n backend &>/dev/null; then
  echo "❌ NetworkPolicy 'policy-x' appliquée - beaucoup trop permissive (autorise tout)"
  exit 1
fi

# Check 3: Verify policy details for policy-z
if kubectl get networkpolicy policy-z -n backend &>/dev/null; then
  # Check it targets backend pods
  SELECTOR=$(kubectl get networkpolicy policy-z -n backend -o jsonpath='{.spec.podSelector.matchLabels.app}')
  if [ "$SELECTOR" = "backend" ]; then
    echo "✅ Policy cible les pods app=backend"
  fi
  
  # Check it allows from frontend namespace
  NS_SELECTOR=$(kubectl get networkpolicy policy-z -n backend -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels.name}')
  if [ "$NS_SELECTOR" = "frontend" ]; then
    echo "✅ Policy autorise depuis namespace 'frontend'"
  fi
fi

# Check 4: Verify no overly permissive policies
if kubectl get networkpolicy policy-x -n backend &>/dev/null; then
  echo "⚠️  policy-x (trop permissive) est aussi appliquée"
fi

echo ""
echo "🎉 Vérification terminée!"
exit 0
