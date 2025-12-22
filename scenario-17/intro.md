# TLS Configuration

## Contexte

Un deployment nginx existe avec une ConfigMap qui supporte TLSv1.2 et TLSv1.3. Vous devez le configurer pour supporter uniquement TLSv1.3.

## Objectifs

- Modifier une ConfigMap nginx
- Comprendre la configuration SSL/TLS
- Redémarrer un deployment pour appliquer les changements
