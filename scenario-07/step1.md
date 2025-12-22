# Tasks

1. **Créer une nouvelle PriorityClass** nommée `high-priority`:
   - La valeur doit être exactement **une de moins** que la plus haute PriorityClass user-defined existante
   - C'est pour les workloads utilisateur (pas système)

2. **Patcher le deployment** `busybox-logger` dans le namespace `priority` pour utiliser cette nouvelle PriorityClass

## Commandes utiles

```bash
kubectl get priorityclass
kubectl create priorityclass --help
kubectl patch deployment --help
```

<details>
<summary>💡 Indice: Trouver la valeur existante</summary>

```bash
kubectl get pc -o jsonpath='{range .items[*]}{.metadata.name}: {.value}{"\n"}{end}'
```
</details>
