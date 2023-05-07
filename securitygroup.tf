resource "aws_security_group" "sg-container" {
  name        = "Allow_Web"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description     = "HTTP"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-allow_web"
  }
}

resource "aws_security_group" "sg-alb" {
  name        = "Allow_Web_ALB"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description = "HTTP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-allow_alb"
  }
}
