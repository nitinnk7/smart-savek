locals {
  eks_count            = var.create_eks ? 1 : 0
  create_sg_for_master = length(var.cluster_security_group_ids) <= 0 && var.create_eks ? 1 : 0
  create_sg_for_nodes  = length(var.worker_security_group_ids) <= 0 && var.create_eks ? 1 : 0
}
