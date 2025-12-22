# ETCD Troubleshooting

## Contexte

Après une migration du cluster, le kube-apiserver ne démarre plus. Avant la migration, etcd était externe et en HA. Après la migration, l'apiserver pointe vers le mauvais port etcd (peer port 2380 au lieu de client port 2379).

## Objectifs

- Diagnostiquer les problèmes de static pods
- Corriger les manifests kube-apiserver
- Comprendre les ports etcd (2379 client, 2380 peer)
