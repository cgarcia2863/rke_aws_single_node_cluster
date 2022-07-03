variable "aws_instance_name" {
  type = string
}

variable "aws_instance_type" {
  type    = string
  default = "t3.small"
}

variable "aws_instance_ami" {
  type    = string
  default = "ami-0917076ab9780844d"
}

variable "aws_instance_key_name" {
  type    = string
  default = "rke-k8s-ssh"
}

variable "aws_instance_user_name" {
  type    = string
  default = "ec2-user"
}

variable "aws_s3_bucket_name" {
  type    = string
  default = "dummy-s3-bucket"
}

variable "aws_s3_endpoint" {
  type    = string
  default = "s3.amazonaws.com"
}

variable "aws_s3_region" {
  type    = string
  default = "eu-north-1"
}

variable "rke_mgmt_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "rke_service_cluster_ip_range" {
  type    = string
  default = "10.43.0.0/16"
}

variable "rke_cluster_cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "rke_cluster_domain" {
  type    = string
  default = "cluster.local"
}

variable "rke_network_plugin" {
  type    = string
  default = "canal"
}

variable "rke_cluster_dns_server" {
  type    = string
  default = "10.43.0.10"
}

variable "rke_kubernetes_version" {
  type    = string
  default = "v1.22.4-rancher1-1"
}