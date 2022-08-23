output "aws_vpc_peering_connection" {
  value = aws_vpc_peering_connection.this
}

output "aws_vpc_peering_connection_accepter" {
  value = aws_vpc_peering_connection_accepter.peer_accepter
}

output "vpc_peering_id" {
  description = "Peering connection ID"
  value       = aws_vpc_peering_connection.this.id
}

output "vpc_peering_accept_status" {
  description = "Accept status for the connection"
  value       = aws_vpc_peering_connection_accepter.peer_accepter.accept_status
}

output "acceptor_vpc_id" {
  description = "The ID of the accepter VPC"
  value       = aws_vpc_peering_connection_accepter.peer_accepter.vpc_id
}

output "requestor_vpc_id" {
  description = "The ID of the requester VPC"
  value       = aws_vpc_peering_connection_accepter.peer_accepter.peer_vpc_id
}