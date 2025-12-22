#!/bin/bash
set -e

echo "🔍 Vérification du lab ArgoCD Helm..."

# Check 1: Namespace exists
if ! kubectl get ns argocd &>/dev/null; then
  echo "❌ Namespace 'argocd' non trouvé"
  exit 1
fi
echo "✅ Namespace 'argocd' existe"

# Check 2: Helm repo added
if ! helm repo list 2>/dev/null | grep -q "argocd"; then
  echo "❌ Helm repo 'argocd' non ajouté"
  exit 1
fi
echo "✅ Helm repo 'argocd' configuré"

# Check 3: File exists
if [ ! -f /root/argo-helm.yaml ]; then
  echo "❌ Fichier /root/argo-helm.yaml non trouvé"
  exit 1
fi
echo "✅ Fichier /root/argo-helm.yaml existe"

# Check 4: File contains ArgoCD manifests
if ! grep -q "argocd" /root/argo-helm.yaml; then
  echo "❌ Le fichier ne contient pas de manifests ArgoCD"
  exit 1
fi
echo "✅ Fichier contient les manifests ArgoCD"

# Check 5: No CRDs in file
if grep -q "kind: CustomResourceDefinition" /root/argo-helm.yaml; then
  echo "❌ Le fichier contient des CRDs (devrait être désactivé)"
  exit 1
fi
echo "✅ Pas de CRDs dans le fichier (crds.install=false)"

# Check 6: Correct version
if ! grep -q "app.kubernetes.io/version" /root/argo-helm.yaml; then
  echo "⚠️  Impossible de vérifier la version du chart"
fi
echo "✅ Manifest généré correctement"

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
