# Tasks

1. **Modifier la ConfigMap** `nginx-config` pour supporter uniquement TLSv1.3
   - Retirer TLSv1.2 de `ssl_protocols`

2. **Ajouter l'IP du service** dans `/etc/hosts`:
   - Hostname: `ckaquestion.k8s.local`

3. **Vérifier** avec les commandes:
   ```bash
   curl -vk --tls-max 1.2 https://ckaquestion.k8s.local  # doit échouer
   curl -vk --tlsv1.3 https://ckaquestion.k8s.local      # doit fonctionner
   ```

## Commandes utiles

```bash
kubectl get svc -n nginx-static
kubectl edit cm nginx-config -n nginx-static
kubectl rollout restart deployment -n nginx-static nginx-static
```

<details>
<summary>Indice: Modification ConfigMap</summary>

Changer `ssl_protocols TLSv1.2 TLSv1.3;` en `ssl_protocols TLSv1.3;`
</details>
