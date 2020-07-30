resource "aws_eks_node_group" "observ-sec-eks-node-group" {
  cluster_name    = aws_eks_cluster.observ-sec-eks-node-group.name
  node_group_name = "observ-sec-eks-node-group"
  node_role_arn   = aws_iam_role.observ-sec-eks-node-group-node.arn
  subnet_ids      = aws_subnet.observ-sec-eks-node-group[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.observ-sec-eks-node-group-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.observ-sec-eks-node-group-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.observ-sec-eks-node-group-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
