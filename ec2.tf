resource "aws_instance" "pp-signeasy" {
  count = 1
  availability_zone = var.azs[0]  
  subnet_id = aws_subnet.pp-public-subnet[0].id  
  ami           = var.ami
  instance_type = var.ec2-instance-type
  vpc_security_group_ids = [aws_security_group.pp-public-subnet-sg.id]
  key_name = "pp-terraform"
  associate_public_ip_address = "true"

  tags = {
    Name = "pp-signeasy-${count.index +1}"
  }
}

resource "aws_instance" "pp-signeasy2" {
  count = 1
  availability_zone = var.azs[1]  
  subnet_id = aws_subnet.pp-public-subnet[1].id  
  ami           = var.ami
  instance_type = var.ec2-instance-type
  vpc_security_group_ids = [aws_security_group.pp-public-subnet-sg.id]
  key_name = "pp-terraform"
  associate_public_ip_address = "true"

  tags = {
    Name = "pp-signeasy2-${count.index +1}"
  }
}
resource "aws_instance" "pp-signeasy3" {
  count = 1
  availability_zone = var.azs[2]  
  subnet_id = aws_subnet.pp-public-subnet[2].id  
  ami           = var.ami
  instance_type = var.ec2-instance-type
  vpc_security_group_ids = [aws_security_group.pp-public-subnet-sg.id]
  key_name = "pp-terraform"
  associate_public_ip_address = "true"

  tags = {
    Name = "pp-signeasy3-${count.index +1}"
  }
}
resource "aws_instance" "pp-signeasy4" {
  count = 1
  availability_zone = var.azs[0]  
  subnet_id = aws_subnet.pp-private-subnet[0].id  
  ami           = var.ami
  instance_type = var.ec2-instance-type
  vpc_security_group_ids = [aws_security_group.pp-private-subnet-sg.id]
  key_name = "pp-terraform"

  tags = {
    Name = "pp-signeasy4-${count.index +1}"
  }
}
resource "aws_instance" "pp-signeasy5" {
  count = 1
  availability_zone = var.azs[1]  
  subnet_id = aws_subnet.pp-private-subnet[1].id  
  ami           = var.ami
  instance_type = var.ec2-instance-type
  vpc_security_group_ids = [aws_security_group.pp-private-subnet-sg.id]
  key_name = "pp-terraform"

  tags = {
    Name = "pp-signeasy5-${count.index +1}"
  }
}

# ec2 instance for webapp-1
resource "aws_instance" "webapp-pp-signeasy-01" {
  availability_zone = var.azs[0]  
  subnet_id = aws_subnet.pp-public-subnet[0].id  
  ami           = var.webapp-1-ami
  instance_type = var.webapp-1-instance-type
  vpc_security_group_ids = [aws_security_group.pp-public-subnet-sg.id]
  key_name = "pp-terraform"
  associate_public_ip_address = "true"
  iam_instance_profile = "CodeDeploy_Ec2"

  tags = {
    Name = "webapp-pp-signeasy-01"
  }
}

# EC2 instance for webapp-2
resource "aws_instance" "webapp-pp-signeasy-02" {
  availability_zone = var.azs[0]  
  subnet_id = aws_subnet.pp-public-subnet[0].id  
  ami           = var.webapp-2-ami
  instance_type = var.webapp-2-instance-type
  vpc_security_group_ids = [aws_security_group.pp-public-subnet-sg.id]
  key_name = "pp-terraform"
  associate_public_ip_address = "true"
  iam_instance_profile = "CodeDeploy_Ec2"

  tags = {
    Name = "webapp-pp-signeasy-02"
  }
}