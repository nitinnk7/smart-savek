#### For EKS cluster #####
resource "aws_security_group" "cluster" {
  count       = local.create_sg_for_master
  name_prefix = var.name
  description = "EKS cluster security group."
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = format("%s_eks_cluster_sg", var.name)
    },
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  count             = local.create_sg_for_master
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.cluster[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  count                    = length(var.worker_security_group_ids) > 0 ? length(var.worker_security_group_ids) : 1
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.cluster.*.id)
  source_security_group_id = length(var.worker_security_group_ids) > 0 ? var.worker_security_group_ids[count.index] : join("", aws_security_group.workers.*.id)
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}


resource "aws_security_group_rule" "cluster_shared_service_access" {
  count             = length(var.allowed_cidrs) > 0 ? 1 : 0
  description       = "Allow shared services to communicate with the EKS cluster API."
  protocol          = "tcp"
  security_group_id = join("", aws_security_group.cluster.*.id)
  cidr_blocks       = var.allowed_cidrs
  from_port         = 443
  to_port           = 443
  type              = "ingress"
}

###### Node Security Groups #####
resource "aws_security_group" "workers" {
  count       = local.create_sg_for_nodes
  name_prefix = var.name
  description = "Security group for all nodes in the cluster."
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name"                              = format("%s_eks_worker_sg", var.name)
      "kubernetes.io/cluster/${var.name}" = "owned"
    },
  )
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "workers_egress_internet" {
  count             = local.create_sg_for_nodes
  description       = "Allow nodes all egress to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.workers[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "workers_ingress_self" {
  count                    = local.create_sg_for_nodes
  description              = "Allow node to communicate with each other."
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers[count.index].id
  source_security_group_id = aws_security_group.workers[count.index].id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "workers_ingress_cluster" {
  count                    = local.create_sg_for_nodes
  description              = "Allow workers pods to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers[count.index].id
  source_security_group_id = aws_security_group.cluster[count.index].id
  from_port                = 1024
  to_port                  = 65535
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
  count                    = local.create_sg_for_nodes
  description              = "Allow workers Kubelets to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers[count.index].id
  source_security_group_id = aws_security_group.cluster[count.index].id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  count                    = local.create_sg_for_nodes
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers[count.index].id
  source_security_group_id = aws_security_group.cluster[count.index].id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}
