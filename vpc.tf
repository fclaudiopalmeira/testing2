#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

## Data Retrieval Block
data "aws_vpc" "observ-sec-eks" {
 count = "${length(data.aws_vpcs.observ-sec-eks.ids)}"
 id    = element(tolist(data.aws_vpcs.observ-sec-eks.ids), 0)
}

data "aws_subnet_ids" "eks_subnets" {
 vpc_id   = element(tolist(data.aws_vpcs.observ-sec-eks.ids), 0)
}

data "aws_subnet" "eks_subnet" {
  for_each = data.aws_subnet_ids.eks_subnets.ids
  id    = each.value
}

# Resources Blocks
resource "aws_vpc" "observ-sec-eks" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-observ-sec-eks-node",
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
    "Name", "terraform-eks-observ-sec-eks-node",
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
  for_each                         = {for s in data.aws_subnet.eks_subnets: s.ids => s}
  subnet_id      = each.value.ids
  route_table_id = aws_route_table.observ-sec-eks.id
}
