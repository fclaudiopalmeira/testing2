variable "subnet_numbers" {
  description = "Map from availability zone to the number that should be used for each availability zone's subnet"
  default     = {
    "ap-southeast-2a" = 1
    "ap-southeast-2b" = 2
    "ap-southeast-2c" = 3
  }
}

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

variable "vpc_id" {
  default = ""
}

variable "subnet_ids" {
  type = map
  description = "Map with all generated subnest from the vpc module"
  default     = ""
}
