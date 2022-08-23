resource "aws_vpc_peering_connection" "this" {
 
  peer_vpc_id   = var.acceptor_vpc_id
  vpc_id        = var.requestor_vpc_id
  peer_region   = var.acceptor_region
   tags = {
    Name        = var.tags_name
  }
}

######################################
# VPC peering accepter configuration #
######################################

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = var.auto_accept_peering
}


###################
# This VPC Routes #  Route from THIS route table to PEER cidr
###################

data "aws_route_tables" "requester" {
  vpc_id = var.requestor_vpc_id

  filter {
    name   = "tag:Name"

    values = ["vpc_eks_rtc-*"]
  }
}

data "aws_route_tables" "accepter" {
  vpc_id = var.acceptor_vpc_id

  filter {
    name   = "tag:Name"

    values = ["vpc_rds_rtc-*"]
  }
}

resource "aws_route" "vpc-peering-route-requester" {
count = length(data.aws_route_tables.requester.ids)
route_table_id = tolist(data.aws_route_tables.requester.ids)[count.index]
destination_cidr_block = var.acceptor_route
vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "vpc-peering-route-accepter" {
count = length(data.aws_route_tables.accepter.ids)
route_table_id = tolist(data.aws_route_tables.accepter.ids)[count.index]
destination_cidr_block = var.requestor_route
vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}