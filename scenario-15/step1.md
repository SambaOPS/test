# Tasks

Le kube-apiserver est down à cause d'une mauvaise configuration etcd.

1. **Diagnostiquer** le problème en vérifiant les logs

2. **Corriger** le fichier manifest du kube-apiserver

3. **Vérifier** que le cluster est fonctionnel

## Fichiers importants

```
/etc/kubernetes/manifests/kube-apiserver.yaml
```

## Commandes utiles

```bash
crictl ps -a
crictl logs <container-id>
journalctl -u kubelet
```

<details>
<summary>Indice: Port etcd</summary>

Le port client etcd est **2379**, pas 2380 (peer port)

Cherchez `--etcd-servers` dans le manifest
</details>
