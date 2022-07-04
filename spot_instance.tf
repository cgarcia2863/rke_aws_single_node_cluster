resource "aws_spot_instance_request" "k8s_master" {
  count                = var.aws_spot_instance ? 1 : 0
  spot_price           = var.aws_spot_price
  spot_type            = "persistent"
  wait_for_fulfillment = true
  tags                 = {}
  subnet_id            = aws_subnet.k8s_public.id
  vpc_security_group_ids = [
    aws_security_group.k8s_master_outbound.id,
    aws_security_group.k8s_master_management.id,
    aws_security_group.k8s_master_https.id
  ]
  iam_instance_profile = aws_iam_instance_profile.k8s_master_role.name
  instance_type        = var.aws_instance_type
  ami                  = var.aws_instance_ami
  key_name             = aws_key_pair.k8s_master_ssh.key_name
  user_data            = file("${path.module}/templates/userdata.sh")
}

data "aws_instance" "k8s_master" {
  count = var.aws_spot_instance ? 1 : 0
  filter {
    name   = "ip-address"
    values = [aws_spot_instance_request.k8s_master.0.public_ip]
  }
}

resource "aws_ec2_tag" "cluster_id" {
  count       = var.aws_spot_instance ? 1 : 0
  resource_id = data.aws_instance.k8s_master.0.id
  key         = "kubernetes.io/cluster/${var.aws_instance_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "name" {
  count       = var.aws_spot_instance ? 1 : 0
  resource_id = data.aws_instance.k8s_master.0.id
  key         = "Name"
  value       = var.aws_instance_name
}