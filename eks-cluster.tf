resource "aws_security_group" "observ-sec-eks-cluster" {
  name        = "terraform-eks-observ-sec-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.observ-sec-eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-observ-sec-eks"
  }
}

resource "aws_security_group_rule" "observ-sec-eks-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.observ-sec-eks-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "observ-sec-eks" {
  name     = var.cluster-name
  role_arn = aws_iam_role.observ-sec-eks-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.observ-sec-eks-cluster.id]
    subnet_ids         = aws_subnet.observ-sec-eks[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.observ-sec-eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.observ-sec-eks-cluster-AmazonEKSServicePolicy,
  ]
}
