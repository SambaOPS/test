# MariaDB Persistent Volume Recovery

## Contexte

Un utilisateur a accidentellement supprimé le Deployment MariaDB dans le namespace `mariadb`. Le deployment était configuré avec du stockage persistant.

Votre responsabilité est de rétablir le deployment tout en préservant les données en réutilisant le PersistentVolume disponible.

## Objectifs

- Comprendre le cycle de vie des PV/PVC
- Savoir recréer un PVC pour réutiliser un PV existant
- Configurer correctement un Deployment avec du stockage persistant

## Environnement

Le script de setup a préparé :
- Un namespace `mariadb`
- Un PersistentVolume `mariadb-pv` (retained et prêt à être réutilisé)
- Un fichier template de Deployment à `~/mariadb-deploy.yaml`
