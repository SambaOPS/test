# Tasks

Mettre à jour le deployment `wordpress` existant en ajoutant un conteneur sidecar.

1. **Ajouter un conteneur sidecar** nommé `sidecar`:
   - Image: `busybox:stable`
   - Commande: `/bin/sh -c tail -f /var/log/wordpress.log`

2. **Utiliser un volume** monté sur `/var/log` pour rendre le fichier `wordpress.log` accessible au conteneur sidecar

## Commandes utiles

```bash
kubectl get deploy wordpress -o yaml
kubectl edit deploy wordpress
```

<details>
<summary>💡 Indice: Structure du volume partagé</summary>

```yaml
volumes:
- name: log
  emptyDir: {}
```

Les deux conteneurs doivent monter ce volume sur `/var/log`
</details>
