locals {
  cluster_id_tag = {
    "kubernetes.io/cluster/${var.aws_instance_name}" = "owned"
  }
}

resource "tls_private_key" "k8s_master_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [aws_instance.k8s_master]
  create_duration = "30s"
}