# Kubernetes v1.28 on AWS using Kubeadm and Terraform

https://www.linkedin.com/pulse/integrating-terraform-ansible-ajay-umredkar/?trk=pulse-article
https://medium.com/geekculture/the-most-simplified-integration-of-ansible-and-terraform-49f130b9fc8

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
Joining the worker nodes manually

### References
- https://github.com/kunchalavikram1427/YouTube_Series/blob/main/Kubernetes/ClusterSetup/Kubernetes_v1.28_on_aws_with_containerd.md