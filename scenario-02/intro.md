# ArgoCD Installation with Helm

## Contexte

Vous devez installer Argo CD dans un cluster Kubernetes en utilisant Helm, tout en vous assurant que les CRDs ne sont pas installés (car ils sont pré-installés).

## Objectifs

- Maîtriser l'ajout de repositories Helm
- Utiliser `helm template` pour générer des manifests
- Configurer les options de chart Helm
