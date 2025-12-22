#!/bin/bash
set -e

echo "🔍 Vérification du lab Sidecar..."

# Check 1: Deployment exists
if ! kubectl get deploy wordpress &>/dev/null; then
  echo "❌ Deployment 'wordpress' non trouvé"
  exit 1
fi
echo "✅ Deployment 'wordpress' existe"

# Check 2: Sidecar container exists
CONTAINERS=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[*].name}')
if ! echo "$CONTAINERS" | grep -q "sidecar"; then
  echo "❌ Container 'sidecar' non trouvé (containers: $CONTAINERS)"
  exit 1
fi
echo "✅ Container 'sidecar' présent"

# Check 3: Sidecar uses correct image
SIDECAR_IMAGE=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].image}')
if [[ "$SIDECAR_IMAGE" != *"busybox"* ]]; then
  echo "❌ Sidecar n'utilise pas busybox (image: $SIDECAR_IMAGE)"
  exit 1
fi
echo "✅ Sidecar utilise busybox"

# Check 4: Shared volume exists
VOLUMES=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.volumes[*].name}')
if [ -z "$VOLUMES" ]; then
  echo "❌ Aucun volume défini"
  exit 1
fi
echo "✅ Volume partagé configuré"

# Check 5: Both containers mount the volume
WP_MOUNTS=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[?(@.name=="wordpress")].volumeMounts[*].mountPath}')
SC_MOUNTS=$(kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].volumeMounts[*].mountPath}')
if [[ "$WP_MOUNTS" != *"/var/log"* ]] || [[ "$SC_MOUNTS" != *"/var/log"* ]]; then
  echo "❌ Volume non monté sur /var/log dans les deux containers"
  exit 1
fi
echo "✅ Volume monté sur /var/log dans les deux containers"

# Check 6: Pod is running
READY=$(kubectl get deploy wordpress -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "1" ]; then
  echo "❌ Pod n'est pas ready"
  exit 1
fi
echo "✅ Pod est running"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
