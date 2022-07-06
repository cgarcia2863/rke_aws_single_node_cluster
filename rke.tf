resource "rke_cluster" "k8s" {
  cluster_name       = var.aws_instance_name
  kubernetes_version = var.rke_kubernetes_version
  addons             = var.rke_addons
  cloud_provider {
    name = "aws"
    aws_cloud_provider {
      global {
        kubernetes_cluster_id = var.aws_instance_name
      }
    }
  }
  nodes {
    address           = time_sleep.wait_for_instance.triggers["public_ip"]
    internal_address  = var.aws_spot_instance ? aws_spot_instance_request.k8s_master.0.private_ip : aws_instance.k8s_master.0.private_ip
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
    etcd {
      uid = var.rke_etcd_uid
      gid = var.rke_etcd_gid
      backup_config {
        enabled        = true
        interval_hours = var.rke_etcd_backup_interval
        retention      = var.rke_etcd_backup_retention
        s3_backup_config {
          bucket_name = var.aws_s3_bucket_name
          endpoint    = var.aws_s3_endpoint
          region      = var.aws_s3_region
        }
      }
    }
  }
  network {
    plugin = var.rke_network_plugin
  }
  authentication {
    strategy = "x509"
  }
  authorization {
    mode    = "rbac"
    options = {}
  }
  ingress {
    provider      = "nginx"
    http_port     = 80
    https_port    = 443
    network_mode  = var.rke_ingress_network_mode
    extra_args    = var.rke_ingress_extra_args
    options       = var.rke_ingress_options
    node_selector = {}
  }
  dns {
    provider             = "coredns"
    node_selector        = {}
    reverse_cidrs        = []
    upstream_nameservers = []
  }
  monitoring {
    provider      = "metrics-server"
    node_selector = {}
    options       = {}
  }
}