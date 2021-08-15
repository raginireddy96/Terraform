# application loadbalancer for webapp
resource "aws_lb" "webapp-elb" {
  name               = "webapp-elb"
  internal           = "false"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pp-public-subnet-sg.id]
  subnets            = [aws_subnet.pp-public-subnet[0].id,aws_subnet.pp-public-subnet[1].id]

  tags = {
    Environment = "pp"
  }
}

#Target group for loadbalancer
resource "aws_lb_target_group" "webapp-tg" {
  name     = "webapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.pp-vpc.id
  health_check {
    interval = 30
    path = "/healthok.html"
    healthy_threshold = 5
    unhealthy_threshold = 2
  }

}
# 443 Listener for webapp loadbalancer
resource "aws_lb_listener" "webapp-listner-1" {
  load_balancer_arn = aws_lb.webapp-elb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-tg.arn
  }
}


# Register the insyances with loadbalancer
resource "aws_lb_target_group_attachment" "webapp-01" {
  target_group_arn = aws_lb_target_group.webapp-tg.arn
  target_id        = aws_instance.webapp-pp-signeasy-01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "webapp-02" {
  target_group_arn = aws_lb_target_group.webapp-tg.arn
  target_id        = aws_instance.webapp-pp-signeasy-02.id
  port             = 80
}

