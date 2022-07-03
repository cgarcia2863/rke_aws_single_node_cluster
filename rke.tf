resource "rke_cluster" "k8s" {
  depends_on = [time_sleep.wait_30_seconds]

  cluster_name       = var.aws_instance_name
  kubernetes_version = var.rke_kubernetes_version
  cloud_provider {
    name = "aws"
    aws_cloud_provider {
      global {
        kubernetes_cluster_id = var.aws_instance_name
      }
    }
  }
  nodes {
    address           = aws_instance.k8s_master.public_ip
    internal_address  = aws_instance.k8s_master.private_ip
    hostname_override = "master"
    port              = "22"
    user              = var.aws_instance_user_name
    role = [
      "controlplane",
      "worker",
      "etcd"
    ]
    ssh_key = tls_private_key.k8s_master_ssh.private_key_openssh
    labels  = {}
  }
  services {
    kube_api {
      service_cluster_ip_range = var.rke_service_cluster_ip_range
      pod_security_policy      = false
      always_pull_images       = false
      secrets_encryption_config {
        enabled = true
      }
    }
    kube_controller {
      cluster_cidr             = var.rke_cluster_cidr
      service_cluster_ip_range = var.rke_service_cluster_ip_range
      extra_args = {
        cluster-signing-cert-file = "/etc/kubernetes/ssl/kube-ca.pem"
        cluster-signing-key-file  = "/etc/kubernetes/ssl/kube-ca-key.pem"
      }
    }
    kubelet {
      cluster_domain               = var.rke_cluster_domain
      cluster_dns_server           = var.rke_cluster_dns_server
      generate_serving_certificate = true
    }
  }
  network {
    plugin = var.rke_network_plugin
  }
  authentication {
    strategy = "x509"
  }
  authorization {
    mode = "rbac"
  }
  ingress {
    provider = "nginx"
    node_selector = {
      "app" = "ingress"
    }
  }
  dns {
    provider = "coredns"
  }
  monitoring {
    provider = "metrics-server"
  }
}