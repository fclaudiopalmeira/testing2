## IAM Resources
# EKS cluster role
resource "aws_iam_role" "observ-sec-eks-cluster-role" {
  # Role config
  name = "${var.cluster-name}-cluster-role"
  # STS assume role policy statement
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
# Managed policy attachments for EKS cluster role
resource "aws_iam_role_policy_attachment" "observ-sec-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.observ-sec-eks-cluster-role.name
}
resource "aws_iam_role_policy_attachment" "observ-sec-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.observ-sec-eks-cluster-role.name
}
# Managed worker node group role
resource "aws_iam_role" "observ-sec-eks-node-group-role" {
  # Role config
  name = "${var.cluster-name}-node-group-role"
  # STS assume role policy statement
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
# Managed policy attachments for worker node group role
resource "aws_iam_role_policy_attachment" "observ-sec-eks-node-group-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.observ-sec-eks-node-group-role.name
}
resource "aws_iam_role_policy_attachment" "observ-sec-eks-node-group-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.observ-sec-eks-node-group-role.name
}
resource "aws_iam_role_policy_attachment" "observ-sec-eks-node-group-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.observ-sec-eks-node-group-role.name
}
 # ALB ingress controller admin policy
resource "aws_iam_policy" "alb-ingress-controller-admin" {
  # Policy config
  name        = "${var.cluster-name}-alb-ingress-admin"
  description = "Permissions required by the AWS ALB Ingress Controller to manage AWS Application Load Balancers."
  # Policy statement
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:AddListenerCertificates",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteRule",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:DescribeListenerCertificates",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:ModifyRule",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:RemoveListenerCertificates",
        "elasticloadbalancing:RemoveTags",
        "elasticloadbalancing:SetIpAddressType",
        "elasticloadbalancing:SetSecurityGroups",
        "elasticloadbalancing:SetSubnets",
        "elasticloadbalancing:SetWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole",
        "iam:GetServerCertificate",
        "iam:ListServerCertificates"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "waf-regional:GetWebACLForResource",
        "waf-regional:GetWebACL",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "tag:GetResources",
        "tag:TagResources"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "waf:GetWebACL"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
# Policy attachment for ALB ingress controller
resource "aws_iam_role_policy_attachment" "observ-sec-eks-node-group-role-alb-ingress-controller-admin" {
  policy_arn = aws_iam_policy.alb-ingress-controller-admin.arn
  role       = aws_iam_role.observ-sec-eks-node-group-role.name
}

########### Cluster Autoscaler admin policy #####################
resource "aws_iam_policy" "cluster-autoscaler-admin" {
  # Policy config
  name        = "${var.cluster-name}-cluster-autoscaler-admin"
  description = "Permissions required by the AWS ALB Ingress Controller to manage AWS Application Load Balancers."

  # Policy statement
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

##################33 Policy attachment for the Cluster Autoscaler, this policy like the alb one, is attached to the nodes ################3
resource "aws_iam_role_policy_attachment" "observ-sec-eks-node-group-role-cluster-autoscaler-admin" {
  policy_arn = aws_iam_policy.cluster-autoscaler-admin.arn
  role       = aws_iam_role.observ-sec-eks-node-group-role.name
}

###########  IAM policy for the CNI metrics helper #####################
resource "aws_iam_policy" "cni-metrics-helper" {
  # Policy config
  name        = "${var.cluster-name}-cni-metrics-helper"
  description = "Permissions required by the Nodes to publish CNI metrics to cloudwatch."

  # Policy statement
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

##################33 Policy attachment for the CNI Metrics Helper, this policy is attached to the nodes ################3
resource "aws_iam_role_policy_attachment" "observ-sec-eks-node-group-role-cni-metrics-helper" {
  policy_arn = aws_iam_policy.cni-metrics-helper.arn
  role       = aws_iam_role.observ-sec-eks-node-group-role.name
}
