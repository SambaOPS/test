# Tasks

1. **Créer une StorageClass** nommée `local-storage`:
   - Provisioner: `rancher.io/local-path`
   - VolumeBindingMode: `WaitForFirstConsumer`
   - Ne PAS la rendre default initialement

2. **Patcher la StorageClass** pour la rendre default

3. **S'assurer** que `local-storage` est la SEULE default class

## Commandes utiles

```bash
kubectl get sc
kubectl patch storageclass <name> -p '...'
```

<details>
<summary>Indice: Annotation default</summary>

```yaml
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
```
</details>
