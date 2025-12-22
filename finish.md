# Félicitations ! 🎉

✅ Repository Helm ArgoCD ajouté  
✅ Namespace argocd créé  
✅ Manifest généré sans CRDs  

## Solution

```bash
kubectl create namespace argocd
helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update
helm template argocd argocd/argo-cd --version 7.7.3 \
  --set crds.install=false --namespace argocd > /root/argo-helm.yaml
```

## 📹 Video Solution
https://youtu.be/e0YGRSjb8CU
