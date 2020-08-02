module "vpc" {
  source = "./vpc"
  cluster-name = "terraform-eks-observ-sec-eks-cluster"
  
 
}

module "eks" {
  source = "./eks"
  cluster-name = "terraform-eks-observ-sec-eks-cluster"
  vpc_id = aws_vpc.observ-sec-eks.id
  subnet_ids = flatten([data.aws_subnet_ids.eks_subnets.*.ids])
  vpc_id = module.vpc.aws_vpc.observ-sec-eks.id
}