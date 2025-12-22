# Tasks

Installer un CNI de votre choix qui remplit ces critères:

1. **Communication Pod-to-Pod** fonctionnelle
2. **Support des NetworkPolicy**
3. **Installation via manifest**

## Options

**Flannel** (v0.26.1):
```
https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
```

**Calico** (v3.28.2) - Recommandé pour NetworkPolicy:
```
https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
```

## Commandes utiles

```bash
kubectl create -f <url>
kubectl get pods -n kube-system
kubectl get pods -n tigera-operator
```

<details>
<summary>💡 Note importante</summary>

⚠️ **Flannel ne supporte PAS les NetworkPolicies nativement!**
Pour le support NetworkPolicy, utilisez Calico.
</details>
