#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

# Resources Blocks
resource "aws_vpc" "observ-sec-eks" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-observ-sec-eks-vpc",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "observ-sec-eks" {
  for_each = var.subnet_numbers
  availability_zone       = each.key
  cidr_block              = cidrsubnet(aws_vpc.observ-sec-eks.cidr_block, 8, each.value)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.observ-sec-eks.id

  tags = map(
    "Name", "terraform-eks-observ-sec-eks-subnets",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
    "kubernetes.io/role/elb", "1"
  )
}

resource "aws_internet_gateway" "observ-sec-eks" {
  vpc_id = aws_vpc.observ-sec-eks.id

  tags = {
    Name = "terraform-eks-observ-sec-eks"
  }
}

resource "aws_route_table" "observ-sec-eks" {
  vpc_id = aws_vpc.observ-sec-eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.observ-sec-eks.id
  }
}

resource "aws_route_table_association" "observ-sec-eks" {
  for_each                         = {for s in data.aws_subnet.eks_subnets: s.id => s}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.observ-sec-eks.id
}
