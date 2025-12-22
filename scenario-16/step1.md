# Tasks

1. **Configurer le deployment** pour exposer le port 80:
   - name: `http`
   - containerPort: 80
   - protocol: TCP

2. **Créer un Service** nommé `nodeport-service`:
   - Type: NodePort
   - Port: 80
   - TargetPort: 80
   - NodePort: 30080

## Commandes utiles

```bash
kubectl get deploy nodeport-deployment -n relative -o yaml
kubectl patch deployment --help
kubectl expose --help
```

<details>
<summary>Indice: Patch ports</summary>

```bash
kubectl patch deployment nodeport-deployment -n relative -p '{
  "spec":{"template":{"spec":{"containers":[{
    "name":"nginx",
    "ports":[{"name":"http","containerPort":80,"protocol":"TCP"}]
  }]}}}}'
```
</details>
