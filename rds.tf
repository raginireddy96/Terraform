 #Create subnet groups for RDS
resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.pp-public-subnet[0].id, aws_subnet.pp-public-subnet[1].id, aws_subnet.pp-public-subnet[2].id, aws_subnet.pp-private-subnet[0].id, aws_subnet.pp-private-subnet[1].id]

  tags = {
    Name = "rds-subnet-group"
  }
}

# Create RDS for dev1-pspdfkit-server DB
resource "aws_db_instance" "pspdfkit-server" {
  allocated_storage    = 40
  availability_zone    = var.azs[0]
  db_subnet_group_name = "rds-subnet-group" 
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.6"
  identifier           = "pspdfkit-server"
  #license_model        = "Postgresql-License"
  instance_class       = var.pspdfkit-rds-instance-type
  name                 = "pspdfkit"
  username             = var.pspdfkit-rds-user
  password             = var.pspdfkit-rds-password
  #final_snapshot_identifier = "pspdfkit-server"
  skip_final_snapshot      = "true"
  vpc_security_group_ids   = [aws_security_group.RDS-security-group.id]
}

# Creating RDS for se-pp
resource "aws_db_instance" "se-pp" {
  allocated_storage    = 40
  max_allocated_storage = 100
  availability_zone    = var.azs[2]
  db_subnet_group_name = "rds-subnet-group" 
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.22"
  identifier           = "se-pp"
  #license_model        = "General-Public-License"
  instance_class       = var.se-pp-rds-instance-type
  name                 = "rds_se_production"
  username             = var.se-pp-rds-user
  password             = var.se-pp-rds-password
  #final_snapshot_identifier = "pspdfkit-server"
  skip_final_snapshot      = "true"
  vpc_security_group_ids   = [aws_security_group.RDS-security-group.id]
}

