#!/bin/bash
set -e

echo "🔍 Vérification du lab StorageClass..."

# Check 1: StorageClass exists
if ! kubectl get sc local-storage &>/dev/null; then
  echo "❌ StorageClass 'local-storage' non trouvée"
  exit 1
fi
echo "✅ StorageClass 'local-storage' existe"

# Check 2: Correct provisioner
PROVISIONER=$(kubectl get sc local-storage -o jsonpath='{.provisioner}')
if [ "$PROVISIONER" != "rancher.io/local-path" ]; then
  echo "❌ Provisioner incorrect (actuel: $PROVISIONER)"
  exit 1
fi
echo "✅ Provisioner = rancher.io/local-path"

# Check 3: VolumeBindingMode
BINDING=$(kubectl get sc local-storage -o jsonpath='{.volumeBindingMode}')
if [ "$BINDING" != "WaitForFirstConsumer" ]; then
  echo "❌ VolumeBindingMode incorrect (actuel: $BINDING)"
  exit 1
fi
echo "✅ VolumeBindingMode = WaitForFirstConsumer"

# Check 4: Is default
IS_DEFAULT=$(kubectl get sc local-storage -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}')
if [ "$IS_DEFAULT" != "true" ]; then
  echo "❌ StorageClass n'est pas default (is-default-class: $IS_DEFAULT)"
  exit 1
fi
echo "✅ StorageClass est default"

# Check 5: Only one default
DEFAULT_COUNT=$(kubectl get sc -o json | jq '[.items[] | select(.metadata.annotations["storageclass.kubernetes.io/is-default-class"] == "true")] | length')
if [ "$DEFAULT_COUNT" -gt 1 ]; then
  echo "⚠️  Il y a $DEFAULT_COUNT StorageClass default (devrait être 1)"
  kubectl get sc | grep "(default)"
fi
echo "✅ local-storage est la seule default class"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
