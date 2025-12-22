# Félicitations ! 🎉

✅ CRDs cert-manager listés  
✅ Documentation extraite avec kubectl explain  

## Solution

```bash
kubectl get crd | grep cert-manager > /root/resources.yaml
kubectl explain certificate.spec.subject > /root/subject.yaml
```

## 📹 Video Solution
https://youtu.be/SA1DzLQaDJs
