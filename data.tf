## Data sources Retrieval Block
# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_vpcs" "observ-sec-eks" {
  filter {
    name   = "tag:Name"
    values = ["terraform-eks-observ-sec-eks-vpc"]
  }
}

data "aws_vpc" "observ-sec-eks" {
 count = "${length(module.vpc.aws_vpcs.observ-sec-eks.ids)}"
 id    = element(tolist(module.vpc.aws_vpcs.observ-sec-eks.ids), 0)
}

data "aws_subnet_ids" "eks_subnets" {
 vpc_id   = element(tolist(module.vpc.aws_vpcs.observ-sec-eks.ids), 0)
}

data "aws_subnet" "eks_subnets" {
  for_each = module.vpc.aws_subnet_ids.eks_subnets.ids
  id    = each.value
}
