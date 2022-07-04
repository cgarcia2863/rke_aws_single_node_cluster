resource "aws_instance" "k8s_master" {
  count                = var.aws_spot_instance ? 0 : 1
  instance_type        = var.aws_instance_type
  ami                  = var.aws_instance_ami
  subnet_id            = aws_subnet.k8s_public.id
  key_name             = aws_key_pair.k8s_master_ssh.key_name
  iam_instance_profile = aws_iam_instance_profile.k8s_master_role.name

  tags = merge(
    { "Name" = var.aws_instance_name },
    local.cluster_id_tag
  )

  vpc_security_group_ids = [
    aws_security_group.k8s_master_outbound.id,
    aws_security_group.k8s_master_management.id,
    aws_security_group.k8s_master_https.id
  ]
  user_data = file("${path.module}/templates/userdata.sh")
}

resource "aws_key_pair" "k8s_master_ssh" {
  key_name   = var.aws_instance_key_name
  public_key = tls_private_key.k8s_master_ssh.public_key_openssh
  tags = {
    "Name" = var.aws_instance_key_name
  }
}