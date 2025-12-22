#!/bin/bash
set -e
kubectl create ns cert-manager --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml
echo "✅ Lab ready!"
