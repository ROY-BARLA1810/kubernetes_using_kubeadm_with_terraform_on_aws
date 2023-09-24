output "publicIP" {
  value = aws_instance.k8s_master.public_ip
}

output "worker_instance_ips" {
  value = aws_instance.k8s_worker[*].public_ip
}