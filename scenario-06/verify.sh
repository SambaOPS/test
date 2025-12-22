#!/bin/bash
set -e

echo "🔍 Vérification du lab CRDs..."

# Check 1: File resources.yaml exists
if [ ! -f /root/resources.yaml ]; then
  echo "❌ Fichier /root/resources.yaml non trouvé"
  exit 1
fi
echo "✅ Fichier /root/resources.yaml existe"

# Check 2: File contains cert-manager CRDs
if ! grep -q "cert-manager" /root/resources.yaml; then
  echo "❌ /root/resources.yaml ne contient pas les CRDs cert-manager"
  exit 1
fi
echo "✅ CRDs cert-manager listés"

# Check 3: File subject.yaml exists
if [ ! -f /root/subject.yaml ]; then
  echo "❌ Fichier /root/subject.yaml non trouvé"
  exit 1
fi
echo "✅ Fichier /root/subject.yaml existe"

# Check 4: subject.yaml contains explanation
if [ ! -s /root/subject.yaml ]; then
  echo "❌ /root/subject.yaml est vide"
  exit 1
fi
echo "✅ Documentation subject extraite"

# Check 5: subject.yaml contains relevant info
if grep -qi "subject\|organization\|country\|province" /root/subject.yaml; then
  echo "✅ Documentation contient les champs subject"
else
  echo "⚠️  Vérifiez que le bon champ a été documenté"
fi

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
