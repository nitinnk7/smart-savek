########################### EKS Cluster ###########################

module "eks" {
  source                  = "../modules/terraform-aws-eks"
  create_eks              = true
  name                    = local.eks_name
  k8s_version             = "1.32"
  endpoint_private_access = true
  endpoint_public_access  = false
  #additional_assume_role_principals = []

  ### This is added for Terraform cloud can access EKS to deploy ingress and other helm charts
  #public_access_cidrs = var.public_access_cidrs
  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id

  create_elb_service_linked_role = false

  cluster_log_retention_in_days = 30

  allowed_cidrs = ["10.10.0.0/16"]
  tags = merge(
    local.additional_tags,
    {
      "kubernetes.io/cluster/${local.eks_name}" = "owned"
    },
    {
      "Environment" = format("%s", var.environment)
    },
    {
      "karpenter.sh/discovery" = format("%s", local.eks_name)
    }
  )
}


#################### EKS Cluster Nodegroup with EBS encrypted GP3###########################
module "eks_ng_gp3" {
  source = "../modules/terraform-aws-eks-ng-encrypted"

  name            = local.eks_name
  cluster_name    = module.eks.eks_id
  node_group_name = "${local.eks_name}-ng"

  node_role_arn   = module.eks.nodes_role_arn[0]
  ami_type        = "AL2023_x86_64_STANDARD"
  disk_size       = 180
  #instance_types  = ["c5.4xlarge"]
  instance_types  = ["m5.xlarge"] 
  #release_version = "1.32.8-20250915"

  security_groups = [module.eks.worker_nodes_sg_id]
  #remote_access = var.remote_access
  k8s_version = "1.32"

  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id

  scaling_config = { "desired_size" = 1, "max_size" = 2, "min_size" = 1 }

  labels = {
    "environment" = var.environment,
    "node_group"  = "${local.eks_name}-application"
  }
}

#################### EKS Add-ons ###########################

# Amazon EBS CSI Driver
# resource "aws_eks_addon" "ebscsi" {
#   cluster_name = module.eks.eks_id
#   addon_name   = "aws-ebs-csi-driver"
#   #addon_version     = "v1.48.0-eksbuild.2"
#   #resolve_conflicts = "OVERWRITE"
  
#   tags = merge(local.additional_tags, {
#     Name = "${local.eks_name}-ebs-csi-driver"
#   })
# }

# Amazon EFS CSI Driver
resource "aws_eks_addon" "efscsi" {
  cluster_name = module.eks.eks_id
  addon_name   = "aws-efs-csi-driver"
  #addon_version     = "v2.1.11-eksbuild.1"
  #resolve_conflicts = "OVERWRITE"
  
  tags = merge(local.additional_tags, {
    Name = "${local.eks_name}-efs-csi-driver"
  })
}

# CoreDNS
resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.eks_id
  addon_name   = "coredns"
  #addon_version     = "v1.11.3-eksbuild.1"
  #resolve_conflicts = "OVERWRITE"
  
  tags = merge(local.additional_tags, {
    Name = "${local.eks_name}-coredns"
  })
}

# kube-proxy
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.eks_id
  addon_name   = "kube-proxy"
  #addon_version     = "v1.31.10-eksbuild.12"
  #resolve_conflicts = "OVERWRITE"
  
  tags = merge(local.additional_tags, {
    Name = "${local.eks_name}-kube-proxy"
  })
}

# Amazon VPC CNI
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.eks_id
  addon_name   = "vpc-cni"
  #addon_version     = "v1.19.0-eksbuild.1"
  #resolve_conflicts = "OVERWRITE"
  
  tags = merge(local.additional_tags, {
    Name = "${local.eks_name}-vpc-cni"
  })
}