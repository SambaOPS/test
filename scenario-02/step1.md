# Tasks

1. **Ajouter le repository Helm officiel ArgoCD** avec le nom `argocd`
   - URL: `https://argoproj.github.io/argo-helm`

2. **Créer un namespace** appelé `argocd`

3. **Générer un template Helm** à partir du chart ArgoCD:
   - Version du chart: `7.7.3`
   - Namespace: `argocd`
   - **Les CRDs ne doivent PAS être installés**

4. **Sauvegarder le manifest YAML** généré dans `/root/argo-helm.yaml`

## Commandes utiles

```bash
helm repo add <name> <url>
helm repo update
helm template --help
```

<details>
<summary>💡 Indice: Option pour désactiver les CRDs</summary>

```bash
--set crds.install=false
```
</details>
