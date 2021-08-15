variable "AWS-Region" {
    default = "us-east-2"
}
variable "VPC-CIDR" {
    default = "192.168.0.0/16"
}

variable "azs" {
    type = list
    default = ["us-east-2a","us-east-2b","us-east-2c"]
}    


variable "public-sub-cidr" {
    type = list
    default = ["192.168.2.0/24","192.168.4.0/24","192.168.6.0/24"]
}

variable "private-sub-cidr" {
    type = list
    default = ["192.168.8.0/24","192.168.10.0/24"]
}

#data "aws_subnet_ids" "all-subnets-ids" {
 # vpc_id = aws_vpc.pp-vpc.id
#}


# RDS variables
variable "pspdfkit-rds-user" {
    default = "pspdfkit"
}

variable "pspdfkit-rds-password" {
    default = "signeasy123"
}

variable "pspdfkit-rds-instance-type" {
    default = "db.t2.micro"
}

variable "se-pp-rds-user" {
    default = "mastersigneasy"
}

variable "se-pp-rds-password" {
    default = "signeasy123"
}

variable "se-pp-rds-instance-type" {
    default = "db.t2.micro"
}

# Elastic cache variables
variable "pp-filesystem-cache-node-type" {
    default = "cache.t3.micro"
}

variable "pp-filesystem-cache-nodes" {
    default = "1"
}
variable "queue-broker-pp_node-type" {
    default = "cache.t3.micro"
}

variable "queue-broker-num-cache-nodes" {
    default = "1"
}

# EC2 Variables
variable "ami" {
    default = "ami-03657b56516ab7912"
}

variable "ec2-instance-type" {
    default = "t2.medium"
}

# EC2 webapp variables
variable "webapp-1-ami" {
    default = "ami-029925ce4eb3f7c93"
}

variable "webapp-1-instance-type" {
    default = "t2.small"
}

variable "webapp-2-ami" {
    default = "ami-06b029b61b6960d3d"
}

variable "webapp-2-instance-type" {
    default = "t2.small"
}
