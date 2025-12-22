# Tasks

Créer un HorizontalPodAutoscaler nommé `apache-server` dans le namespace `autoscale`.

1. **Target**: deployment `apache-deployment` dans `autoscale`

2. **CPU target**: 50% d'utilisation par Pod

3. **Replicas**:
   - Minimum: 1 pod
   - Maximum: 4 pods

4. **Downscale stabilization**: 30 secondes

## Commandes utiles

```bash
kubectl get deploy -n autoscale
kubectl get hpa -n autoscale
kubectl autoscale --help
```

<details>
<summary>💡 Structure HPA v2</summary>

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
```
</details>
