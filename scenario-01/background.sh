#!/bin/bash
set -e

# Attendre que le cluster soit prêt
echo "⏳ Waiting for Kubernetes cluster to be ready..."
until kubectl get nodes &>/dev/null; do
  sleep 2
done
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "🔹 Creating namespace mariadb..."
kubectl create ns mariadb

echo "🔹 Creating PersistentVolume mariadb-pv..."
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  hostPath:
    path: /mnt/data/mariadb
YAML

echo "🔹 Creating temporary PVC to simulate data..."
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  resources:
    requests:
      storage: 250Mi
YAML

echo "🔹 Creating MariaDB Deployment template..."
cat <<'YAML' > /root/mariadb-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: ""
YAML

echo "🔹 Simulating accidental deletion (PVC only)..."
sleep 5
kubectl delete pvc mariadb -n mariadb --ignore-not-found
kubectl patch pv mariadb-pv --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]' 2>/dev/null || true

echo "✅ Lab setup complete!"
echo "   - Namespace: mariadb"
echo "   - PV: mariadb-pv (Available)"
echo "   - Template: /root/mariadb-deploy.yaml"
