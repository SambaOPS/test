# Tasks

1. **Ajouter un taint** à `node01` pour empêcher les pods normaux d'y être schedulés:
   - Key: `PERMISSION`
   - Value: `granted`
   - Effect: `NoSchedule`

2. **Scheduler un Pod** sur `node01` en ajoutant la toleration correcte

## Commandes utiles

```bash
kubectl taint nodes <node> key=value:effect
kubectl describe node node01 | grep -i taint
```

<details>
<summary>Indice: Structure toleration</summary>

```yaml
tolerations:
- key: "PERMISSION"
  operator: "Equal"
  value: "granted"
  effect: "NoSchedule"
```
</details>
