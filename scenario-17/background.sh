#!/bin/bash
set -e

echo "⏳ Waiting for Kubernetes cluster..."
until kubectl get nodes &>/dev/null; do sleep 2; done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace nginx-static..."
kubectl create namespace nginx-static

echo "🔹 Creating TLS certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=ckaquestion.k8s.local" 2>/dev/null
kubectl -n nginx-static create secret tls nginx-tls --cert=/tmp/tls.crt --key=/tmp/tls.key

echo "🔹 Creating ConfigMap with TLSv1.2 and TLSv1.3..."
cat <<YAML | kubectl -n nginx-static apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/tls/tls.crt;
        ssl_certificate_key /etc/nginx/tls/tls.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        location / {
          return 200 "Hello TLS\n";
        }
      }
    }
YAML

echo "🔹 Creating nginx deployment..."
cat <<YAML | kubectl -n nginx-static apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-static
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-static
  template:
    metadata:
      labels:
        app: nginx-static
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 443
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: tls
          mountPath: /etc/nginx/tls
      volumes:
      - name: config
        configMap:
          name: nginx-config
      - name: tls
        secret:
          secretName: nginx-tls
YAML

echo "🔹 Creating service..."
kubectl -n nginx-static expose deployment nginx-static --port=443 --target-port=443 --name=nginx-static

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=Available deployment/nginx-static -n nginx-static --timeout=120s || true

echo "✅ Lab ready!"
echo "   - Namespace: nginx-static"
echo "   - ConfigMap: nginx-config (TLSv1.2 + TLSv1.3)"
echo "   - Service: nginx-static"
echo "   - Task: Remove TLSv1.2, keep only TLSv1.3"
