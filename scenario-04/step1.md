# Tasks

1. **Scale down** le deployment wordpress à 0 réplicas

2. **Éditer le deployment** et diviser les ressources du node équitablement entre les 3 pods:
   - Assigner CPU et mémoire égaux à chaque Pod
   - Ajouter une marge suffisante pour éviter l'instabilité du node

3. **Les init containers ET les containers principaux** doivent avoir exactement les mêmes requests/limits

4. **Scale up** le deployment à 3 réplicas

## Commandes utiles

```bash
kubectl top nodes
kubectl scale deployment wordpress --replicas=0
kubectl edit deployment wordpress
```

<details>
<summary>💡 Exemple de configuration ressources</summary>

```yaml
resources:
  requests:
    cpu: "300m"
    memory: "600Mi"
  limits:
    cpu: "400m"
    memory: "700Mi"
```
</details>
