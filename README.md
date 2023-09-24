# Kubernetes v1.28 on AWS using Kubeadm and Terraform

### Check logs
Check userdata logs
```sh
cat /var/log/cloud-init-output.log
```

### Test
```
kubectl get nodes
NAME               STATUS   ROLES           AGE     VERSION
NODENAME           Ready    control-plane   3m34s   v1.28.2
NODENAME           Ready    <none>          8s      v1.28.2
******
```

### Known limitations
NA

### References
- https://github.com/kunchalavikram1427/YouTube_Series/blob/main/Kubernetes/ClusterSetup/Kubernetes_v1.28_on_aws_with_containerd.md