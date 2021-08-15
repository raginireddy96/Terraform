# VPC
resource "aws_vpc" "pp-vpc" {
    cidr_block = var.VPC-CIDR
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
      tags = {
        Name = "pp-vpc"
      }

}

# Public subnets
resource "aws_subnet" "pp-public-subnet" {
    count = length(var.public-sub-cidr)
    vpc_id = aws_vpc.pp-vpc.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.public-sub-cidr, count.index)
    map_public_ip_on_launch = "true"
      tags = {
          Name = "pp-public-subnet-${count.index +1}"
      }
  
}

# Private subnets
resource "aws_subnet" "pp-private-subnet" {
    count = length(var.private-sub-cidr)
    vpc_id = aws_vpc.pp-vpc.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.private-sub-cidr, count.index)
      tags = {
          Name = "pp-private-subnet-${count.index +1}"
      }
  
}

# Internet Gateway 

resource "aws_internet_gateway" "PP-IGW" {
    vpc_id = aws_vpc.pp-vpc.id
      tags = {
          Name = "PP-IGW"
      }
}

# Route table and its association for public subnets

resource "aws_route_table" "pub-sub-route-table" {
    vpc_id = aws_vpc.pp-vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.PP-IGW.id
    }
    tags = {
      Name = "pub-sub-route-table"
    }
}
resource "aws_route_table_association" "pub-route-table-association" {
  count = length(var.public-sub-cidr)
  subnet_id = element(aws_subnet.pp-public-subnet.*.id, count.index)
  route_table_id = aws_route_table.pub-sub-route-table.id
}

# Elastic ip for NAT Gateway

resource "aws_eip" "eip" {
  vpc = true
}

# NAT Gateway for private subnets
resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.pp-public-subnet[0].id
  tags = {
    Name = "NAT-GW"
  }
}

# Route table and its association with private subnets
resource "aws_route_table" "private-sub-route-table" {
    vpc_id = aws_vpc.pp-vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.NAT-GW.id
    }
    tags = {
      Name = "private-sub-route-table"
    }
}
resource "aws_route_table_association" "private-route-table-association" {
  count = length(var.private-sub-cidr)
  subnet_id = element(aws_subnet.pp-private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-sub-route-table.id
}

# NACL for both subnets
#subnet ids pass dynamically

resource "aws_network_acl" "Nacl" {
  vpc_id = aws_vpc.pp-vpc.id
  subnet_ids = [aws_subnet.pp-public-subnet[0].id, aws_subnet.pp-public-subnet[1].id, aws_subnet.pp-public-subnet[2].id, aws_subnet.pp-private-subnet[0].id, aws_subnet.pp-private-subnet[1].id]
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Nacl"
  }
}
