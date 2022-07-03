resource "aws_security_group" "k8s_master_outbound" {
  description = "Allow outbound access"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Outbound traffic"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  name = "k8s-outbound-access"
  tags = merge(
    { "Name" = "k8s-outbound-access" },
    local.cluster_id_tag
  )
  vpc_id = aws_vpc.k8s.id
}

resource "aws_security_group" "k8s_master_management" {
  description = "Allow management access SSH,K8s API from specific IP"
  ingress = [
    {
      cidr_blocks      = var.rke_mgmt_cidr_blocks
      description      = "k8s_apiserver_home_ip"
      from_port        = 6443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 6443
    },
    {
      cidr_blocks      = var.rke_mgmt_cidr_blocks
      description      = "ssh_access_home_ip"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 22
    }
  ]
  name = "k8s-management-access"
  tags = merge(
    { "Name" = "k8s-management-access" },
    local.cluster_id_tag
  )
  vpc_id = aws_vpc.k8s.id
}

resource "aws_security_group" "k8s_master_https" {
  description = "Allow HTTPS access from everywhere"
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "https_all_ips"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "http_all_ips"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  name = "k8s-https-access"
  tags = merge(
    { "Name" = "k8s-https-access" },
    local.cluster_id_tag
  )
  vpc_id = aws_vpc.k8s.id
}