# Launch master instance
resource "aws_instance" "k8s_master" {
  ami           = var.ami["master"]
  instance_type = var.instance_type["master"]
  tags = {
    Name = "k8s-master"
  }
  key_name        = aws_key_pair.k8s.key_name
  security_groups = ["k8s_master_sg"]
  user_data = file("master.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("k8s-key")
  }
  provisioner "file" {
    source      = "./set-hostname.sh"
    destination = "/home/ubuntu/set-hostname.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/set-hostname.sh",
      "sudo sh /home/ubuntu/set-hostname.sh k8s-master"
    ]
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
  user_data = file("worker.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("k8s-key")
  }
  provisioner "file" {
    source      = "./set-hostname.sh"
    destination = "/home/ubuntu/set-hostname.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/set-hostname.sh",
      "sudo sh /home/ubuntu/set-hostname.sh k8s-worker-${count.index}"
    ]
  }

}
