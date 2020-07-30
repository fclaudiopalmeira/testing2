#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "observ-sec-eks" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-observ-sec-eks-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "observ-sec-eks" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
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
  count = 2

  subnet_id      = aws_subnet.observ-sec-eks.*.id[count.index]
  route_table_id = aws_route_table.observ-sec-eks.id
}
