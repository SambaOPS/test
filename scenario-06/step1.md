# Tasks

1. **Créer une liste** de tous les CRDs cert-manager et la sauvegarder dans `/root/resources.yaml`

2. **Extraire la documentation** pour le champ `subject` de la spec Certificate et la sauvegarder dans `/root/subject.yaml`
   - Vous pouvez utiliser n'importe quel format de sortie supporté par kubectl

## Commandes utiles

```bash
kubectl get crd
kubectl explain <resource>
kubectl explain <resource>.spec.<field>
```

<details>
<summary>💡 Indice: Filtrer les CRDs</summary>

```bash
kubectl get crd | grep cert-manager
```
</details>
