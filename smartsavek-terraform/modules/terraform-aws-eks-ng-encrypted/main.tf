resource "aws_eks_node_group" "this" {
  count = var.create_node_group ? 1 : 0

  ami_type      = var.ami_type
  capacity_type = var.capacity_type
  cluster_name  = var.cluster_name
  #disk_size       = var.disk_size
  instance_types  = var.instance_types
  labels          = var.labels
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  #release_version = var.release_version
  subnet_ids      = var.subnet_ids
  version         = var.k8s_version

  remote_access {
    ec2_ssh_key               = var.remote_access["ec2_ssh_key"]
    source_security_group_ids = var.remote_access["source_security_group_ids"]
  }

  launch_template {
    id      = aws_launch_template.default.id
    version = aws_launch_template.default.latest_version
  }

  scaling_config {
    desired_size = var.scaling_config["desired_size"]
    max_size     = var.scaling_config["max_size"]
    min_size     = var.scaling_config["min_size"]
  }

  tags = merge(
    var.tags,
    {
      "Node_group_name" = var.node_group_name
    }
  )

  lifecycle {
    ignore_changes = [
      remote_access,
      scaling_config[0].desired_size
    ]
  }
  timeouts {
    create = "1h30m"
    update = "2h"
  }
}
