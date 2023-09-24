# Launchg an instance
resource "aws_instance" "k8s_master" {
  ami           = var.ami["master"]
  instance_type = var.instance_type["master"]

  tags = {
    Name = "k8s-master"
  }

  key_name        = aws_key_pair.k8s.key_name
  security_groups = ["k8s_master_sg"]

  user_data = file("master.sh")

}

# Launchg an instance
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

}
