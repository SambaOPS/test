#!/bin/bash
set -e
kubectl apply -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:php8.2-apache
        command: ["/bin/sh", "-c", "while true; do echo 'WordPress running...' >> /var/log/wordpress.log; sleep 5; done"]
        ports:
        - containerPort: 80
YAML
echo "✅ Lab ready!"
