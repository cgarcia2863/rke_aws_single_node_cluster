locals {
  cluster_id_tag = {
    "kubernetes.io/cluster/${var.aws_instance_name}" = "owned"
  }
}

resource "tls_private_key" "k8s_master_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "time_sleep" "wait_for_instance" {
  create_duration = var.rke_sleep_before_deploy
  triggers = {
    public_ip = var.aws_spot_instance ? aws_spot_instance_request.k8s_master.0.public_ip : aws_instance.k8s_master.0.public_ip
  }
}