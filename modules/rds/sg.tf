resource "aws_security_group" "nonprod-hotel-rds-connect" {
  #name        = "nonprod-hotel-db-sg"
  name        = var.sg_name
  description = "Allow aurora connection form eks to rds"
  #vpc_id      = "vpc-03768100a9e2831b0"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = var.port_cidr_blocks
  }
   ingress {
    from_port   = 0  
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = var.sg_tags
  }
}

