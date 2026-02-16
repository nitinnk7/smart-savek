# Create EKS cluster
resource "aws_eks_cluster" "this" {
  count    = local.eks_count
  name     = var.name
  role_arn = aws_iam_role.eks-master-role[count.index].arn
  version  = var.k8s_version

  enabled_cluster_log_types = var.enabled_cluster_log_types
  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = length(var.cluster_security_group_ids) > 0 ? var.cluster_security_group_ids : aws_security_group.cluster.*.id
    subnet_ids              = var.subnet_ids
  }
  # This Block throwing error message
  # dynamic "kubernetes_network_config" {
  #     for_each = length(keys(var.kubernetes_network_config)) > 0 ? [var.kubernetes_network_config] : []
  #     service_ipv4_cidr = lookup(kubernetes_network_config.value, "service_ipv4_cidr", null)
  # }
  # dynamic "encryption_config" {
  #   for_each = toset(var.cluster_encryption_config)

  #   content {
  #     provider {
  #       key_arn = encryption_config.value["provider_key_arn"]
  #     }
  #     resources = encryption_config.value["resources"]
  #   }
  # }
  

  depends_on = [
    aws_iam_role.eks-master-role,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy
  ]
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
  lifecycle {
    # We cant create more than 1 EKS clusters with the same name, `create_before_destroy` wont work here
    create_before_destroy = true
  #  ignore_changes = [
  #    platform_version,
  #    version,
  #  ]
  }
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = join("", aws_eks_cluster.this.*.identity.0.oidc.0.issuer)
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc_certificate.certificates.0.sha1_fingerprint]
}
