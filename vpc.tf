resource "aws_vpc" "k8s" {
  cidr_block = "10.0.0.0/28"
  tags = merge(
    { "Name" = "k8s" },
    local.cluster_id_tag
  )
}

resource "aws_subnet" "k8s_public" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true
  tags = merge(
    { "Name" = "k8s-public" },
    local.cluster_id_tag
  )
}

resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s.id
  tags = {
    "Name" = "k8s-igw"
  }
}

resource "aws_route_table" "k8s_rt" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_igw.id
  }

  tags = {
    "Name" = "k8s-public-rtb"
  }
}

resource "aws_route_table_association" "k8s_route_to_public_subnet" {
  subnet_id      = aws_subnet.k8s_public.id
  route_table_id = aws_route_table.k8s_rt.id
}