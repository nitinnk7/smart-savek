resource "aws_vpc_peering_connection" "peer" {
  count = var.enable_peering ? 1 : 0

  vpc_id        = var.vpc_id
  peer_vpc_id   = var.peer_vpc_id
  peer_owner_id = var.peer_account_id
  peer_region   = var.peer_region
  auto_accept   = false

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-to-peer"
  })
}

resource "aws_route" "to_peer_vpc" {
  count = var.enable_peering ? length(var.private_route_table_ids) : 0

  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = var.peer_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[0].id
}