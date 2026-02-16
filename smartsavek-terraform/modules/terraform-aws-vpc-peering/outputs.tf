# output "peering_connection_id" {
#   value       = try(aws_vpc_peering_connection.peer[0].id, null)
#   description = "Peering connection ID to be used by peer account"
# }