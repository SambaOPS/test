# Tâches à réaliser

Un PersistentVolume existe déjà et est retenu pour réutilisation. Un seul PV existe dans le cluster.

## Tasks

1. **Créer un PersistentVolumeClaim (PVC)** nommé `mariadb` dans le namespace `mariadb` avec les specs suivantes :
   - Access Mode = `ReadWriteOnce`
   - Storage = `250Mi`

2. **Éditer le fichier Deployment MariaDB** situé à `~/mariadb-deploy.yaml` pour utiliser le PVC créé à l'étape précédente

3. **Appliquer le fichier Deployment** mis à jour au cluster

4. **Vérifier** que le Deployment MariaDB est running et stable

## Commandes utiles

```bash
# Vérifier le PV existant
kubectl get pv

# Vérifier les PVC
kubectl get pvc -n mariadb

# Vérifier le deployment
kubectl get deploy -n mariadb
```

<details>
<summary>💡 Indice 1: Structure du PVC</summary>

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
```
</details>

<details>
<summary>💡 Indice 2: Modification du Deployment</summary>

Dans `~/mariadb-deploy.yaml`, modifiez `claimName: ""` en `claimName: "mariadb"`
</details>
