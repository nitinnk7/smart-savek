###############################################
## This is eks master node IAM roles and policies
###############################################
resource "aws_iam_role" "eks-master-role" {
  count = local.eks_count
  name  = format("%s-eks-master-iam-role", var.name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ],
      length(var.additional_assume_role_principals) > 0 ? [
        {
          Effect = "Allow"
          Principal = {
            AWS = var.additional_assume_role_principals
          }
          Action = "sts:AssumeRole"
        }
      ] : []
    )
  })

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  count      = local.eks_count
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-master-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  count      = local.eks_count
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-master-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

###############################################
## This is eks node IAM roles and policies
###############################################

resource "aws_iam_role" "eks-node-role" {
  count = local.eks_count
  name  = format("%s-eks-node-iam-role", var.name)

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "eks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  lifecycle {
    create_before_destroy = true

  }
}

#### Service account Role for AWS ELB

resource "aws_iam_service_linked_role" "elbservicerole" {
  count            = var.create_elb_service_linked_role ? 1 : 0
  aws_service_name = var.aws_service_name
  #custom_suffix    = var.name
}

resource "aws_iam_role_policy" "s3_readonly_policy" {
  count = local.eks_count
  name  = format("%s-eks-s3-policy", var.name)
  role  = aws_iam_role.eks-node-role[count.index].name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  lifecycle {
    create_before_destroy = true
  }
}
# checkov:skip=CKV_AWS_63 These are needed for EC2 Management
# checkov:skip=CKV_AWS_62 These are needed for EC2 Management
resource "aws_iam_role_policy" "ec2_fullaccess_policy" {
  count = local.eks_count
  name  = format("%s-eks-ec2-policy", var.name)
  role  = aws_iam_role.eks-node-role[count.index].name
  # checkov:skip=CKV_AWS_63 These are needed for EC2 Management
  # checkov:skip=CKV_AWS_62 These are needed for EC2 Management
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  count      = local.eks_count
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  count      = local.eks_count
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
  count      = local.eks_count
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "eks-node" {
  count = local.eks_count
  name  = format("%s-node-instance-profile", var.name)
  role  = aws_iam_role.eks-node-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "demo-node-CloudWatchAgentServerPolicy" {
  count      = local.eks_count
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks-node-role[count.index].name
  lifecycle {
    create_before_destroy = true
  }
}

# KMS policy
data "aws_iam_policy_document" "kms" {
  count = var.create_kms ? 1 : 0

  statement {
    sid = "Enable IAM User Permissions"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
      type        = "AWS"
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

  statement {
    principals {
      identifiers = ["logs.${data.aws_region.this.name}.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      values   = ["arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:/aws/eks/${var.name}/cluster"]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }
}
