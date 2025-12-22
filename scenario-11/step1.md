# Tasks

1. **Créer une ressource Gateway** nommée `web-gateway`:
   - Hostname: `gateway.web.k8s.local`
   - Maintenir la configuration TLS existante de l'Ingress `web`
   - Utiliser la GatewayClass `nginx-class`

2. **Créer une HTTPRoute** nommée `web-route`:
   - Hostname: `gateway.web.k8s.local`
   - Maintenir les règles de routing de l'Ingress existant

## Commandes utiles

```bash
kubectl describe ingress web
kubectl describe secret web-tls
kubectl get gatewayclass
```

<details>
<summary>Indice: Structure Gateway</summary>

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls
```
</details>
