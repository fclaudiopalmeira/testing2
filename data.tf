## Data Retrieval Block
data "aws_vpcs" "observ-sec-eks" {
  filter {
    name   = "tag:Name"
    values = ["terraform-eks-observ-sec-eks-vpc"]
  }
  depends_on = [
    aws_vpc.observ-sec-eks,
  ]
}

data "aws_vpc" "observ-sec-eks" {
 count = "${length(data.aws_vpcs.observ-sec-eks.ids)}"
 id    = element(tolist(data.aws_vpcs.observ-sec-eks.ids), 0)
}

data "aws_subnet_ids" "eks_subnets" {
 vpc_id   = element(tolist(data.aws_vpcs.observ-sec-eks.ids), 0)
}

data "aws_subnet" "eks_subnets" {
  for_each = data.aws_subnet_ids.eks_subnets.ids
  id    = each.value
}
