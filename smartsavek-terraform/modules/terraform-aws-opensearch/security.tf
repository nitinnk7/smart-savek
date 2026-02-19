resource "aws_security_group" "this" {
  count  = var.enabled && var.create_security_group ? 1 : 0
  name   = "${var.name}-opensearch-sg"
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_security_group_rule" "allow_sg" {
  for_each = var.enabled && var.create_security_group ? toset(var.allowed_security_group_ids) : []

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this[0].id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "allow_cidr" {
  for_each = var.enabled && var.create_security_group ? toset(var.allowed_cidr_blocks) : []

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this[0].id
  cidr_blocks       = [each.value]
}
