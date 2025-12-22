# Tasks

1. **Installer le package Debian** `~/cri-dockerd.deb` avec dpkg

2. **Activer et démarrer** le service cri-docker

3. **Configurer ces paramètres sysctl** (de façon persistante):
   - `net.bridge.bridge-nf-call-iptables = 1`
   - `net.ipv6.conf.all.forwarding = 1`
   - `net.ipv4.ip_forward = 1`
   - `net.netfilter.nf_conntrack_max = 131072`

## Commandes utiles

```bash
sudo dpkg -i <package>
sudo systemctl enable --now <service>
sudo sysctl --system
```

<details>
<summary>Indice: Fichier sysctl persistant</summary>

Créer `/etc/sysctl.d/kube.conf` avec les paramètres
</details>
