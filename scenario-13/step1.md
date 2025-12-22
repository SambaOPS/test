# Tasks

1. **Examiner les fichiers NetworkPolicy** dans `/root/network-policies/`

2. **Décider** quelle policy permet l'interaction frontend→backend de la façon **la moins permissive**

3. **Appliquer** cette NetworkPolicy

## Fichiers à analyser

- `/root/network-policies/network-policy-1.yaml`
- `/root/network-policies/network-policy-2.yaml`
- `/root/network-policies/network-policy-3.yaml`

## Commandes utiles

```bash
cat /root/network-policies/*.yaml
kubectl get pods -n frontend --show-labels
kubectl get pods -n backend --show-labels
```

<details>
<summary>Indice: Critères d'analyse</summary>

- `policy-1`: Autorise tout ingress (trop ouvert)
- `policy-2`: Autorise namespace + plage IP (trop ouvert)
- `policy-3`: Autorise uniquement namespace frontend + pods app=frontend
</details>
