# Register a key
resource "aws_key_pair" "k8s" {
  key_name   = "k8s"
  public_key = file("k8s-key.pub") # supply a public key. ssh-keygen -f $PWD/k8s-key
}