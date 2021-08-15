# Security group for RDS
resource "aws_security_group" "RDS-security-group" {
  name        = "RDS-security-group"
  description = "sg"
  vpc_id      = aws_vpc.pp-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.VPC-CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-security-group"
  }
}

# Security group for Redis
resource "aws_security_group" "Redis-security-group" {
  name        = "Redis-security-group"
  description = "sg"
  vpc_id      = aws_vpc.pp-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.VPC-CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Redis-security-group"
  }
}

# Security group for ec2 instances in public subnet
resource "aws_security_group" "pp-public-subnet-sg" {
  name        = "pp-public-subnet-sg"
  description = "sg for instances in public subnet"
  vpc_id      = aws_vpc.pp-vpc.id

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
    Name = "pp-public-subnet-sg"
  }
}

# Security group for ec2 instances in private subnet
resource "aws_security_group" "pp-private-subnet-sg" {
  name        = "pp-private-subnet-sg"
  description = "sg for instances in private subnet"
  vpc_id      = aws_vpc.pp-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.VPC-CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pp-private-subnet-sg"
  }
}