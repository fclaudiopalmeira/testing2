variable "aws_region" {
  default = "ap-southeast-2"
}

variable "cluster-name" {
  default = "terraform-eks-observ-sec-eks-cluster"
  type    = string
}

variable "tags" {
  type = list(string)
  default = ["k8s.io/cluster-autoscaler/enabled"]
  description = "AWS AutoScalingGroup tags."
}
