# Tasks

1. **Exposer le deployment** `echo` avec un Service:
   - Nom: `echo-service`
   - Port: 8080
   - Type: NodePort

2. **Créer un Ingress** nommé `echo` dans `echo-sound`:
   - Host: `example.org`
   - Path: `/echo`
   - Backend: `echo-service` port 8080

## Test

```bash
curl <NODEIP>:<NODEPORT>/echo
```

<details>
<summary>Indice: Exposer rapidement</summary>

```bash
kubectl expose deployment echo -n echo-sound \
  --name echo-service --type NodePort --port 8080 --target-port 8080
```
</details>
