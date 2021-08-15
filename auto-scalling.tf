# Application loadbalancer for v4
resource "aws_lb" "api-v4-elb" {
  name               = "api-v4-elb"
  internal           = "true"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pp-public-subnet-sg.id]
  subnets            = [aws_subnet.pp-public-subnet[0].id,aws_subnet.pp-public-subnet[1].id]

  tags = {
    Environment = "pp"
  }
}

#Target group for loadbalancer
resource "aws_lb_target_group" "api-v4-tg" {
  name     = "api-v4-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.pp-vpc.id
  health_check {
    interval = 30
    path = "/v4/health"
    healthy_threshold = 5
    unhealthy_threshold = 2
  }

}
# Listener for v4 loadbalancer
resource "aws_lb_listener" "v4-elb-listner" {
  load_balancer_arn = aws_lb.api-v4-elb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api-v4-tg.arn
  }
}


#launch configuration for v4
resource "aws_launch_configuration" "api-v4" {
  name = "api-v4"
  image_id = "ami-0811b1e9f38953a2c"
  instance_type = "t2.medium"
  security_groups = [aws_security_group.pp-public-subnet-sg.id]
  iam_instance_profile = "CodeDeploy_Ec2"
  key_name = "pp-terraform"
  lifecycle {
    create_before_destroy = true
  }
  
}
#Autoscalling group for v4
resource "aws_autoscaling_group" "api-v4" {
  name = "api-v4"
  vpc_zone_identifier = [aws_subnet.pp-public-subnet[0].id]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  health_check_type = "EC2"
  health_check_grace_period = 300
  launch_configuration = aws_launch_configuration.api-v4.id
  target_group_arns = [aws_lb_target_group.api-v4-tg.arn]
  
}