# Launch master instance
resource "aws_instance" "k8s_master" {
  ami           = var.ami["master"]
  instance_type = var.instance_type["master"]
  tags = {
    Name = "k8s-master"
  }
  key_name        = aws_key_pair.k8s.key_name
  security_groups = ["k8s_master_sg"]
  # user_data = file("master.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("k8s-key")
  }
  provisioner "file" {
    source      = "./master.sh"
    destination = "/home/ubuntu/master.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/master.sh",
      "sudo sh /home/ubuntu/master.sh k8s-master"
    ]
  }
  provisioner "local-exec" {
    command = "echo [master] >> ./hosts" 
    on_failure = continue
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ./hosts" 
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' playbook.yaml"
  }

}

# Launch worker instance(s)
resource "aws_instance" "k8s_worker" {
  count         = var.worker_instance_count
  ami           = var.ami["worker"]
  instance_type = var.instance_type["worker"]
  tags = {
    Name = "k8s-worker-${count.index}"
  }
  key_name        = aws_key_pair.k8s.key_name
  security_groups = ["k8s_worker_sg"]
  # user_data = file("worker.sh")
  depends_on = [ aws_instance.k8s_master ]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("k8s-key")
  }
  provisioner "file" {
    source      = "./worker.sh"
    destination = "/home/ubuntu/worker.sh"
  }
  provisioner "file" {
    source      = "./join-command.sh"
    destination = "/home/ubuntu/join-command.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/worker.sh /home/ubuntu/join-command.sh",
      "sudo sh /home/ubuntu/worker.sh k8s-worker-${count.index}",
      "sudo sh /home/ubuntu/join-command.sh"
    ]
  }
}

# resource "null_resource" "k8s_worker_ips" {
#   count = length(aws_instance.k8s_worker)
#   depends_on = [ aws_instance.k8s_master, aws_instance.k8s_worker ]
#   provisioner "local-exec" {
#     command = "echo [workers] >> ./hosts" 
#     on_failure = continue
#   }
#   provisioner "local-exec" {
#     command = "echo ${element(aws_instance.k8s_worker[*].public_ip, count.index)} >> hosts"
#   }
# }
