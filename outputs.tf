output "public_ipv4" {
  value = aws_instance.k8s_master.public_ip
}

output "private_ipv4" {
  value = aws_instance.k8s_master.private_ip
}

output "ssh_private_key" {
  value     = tls_private_key.k8s_master_ssh.private_key_openssh
  sensitive = true
}

output "kube_config_yaml" {
  value     = rke_cluster.k8s.kube_config_yaml
  sensitive = true
}

output "rke_cluster_yaml" {
  value     = rke_cluster.k8s.rke_cluster_yaml
  sensitive = true
}

output "rke_state" {
  value     = rke_cluster.k8s.rke_state
  sensitive = true
}