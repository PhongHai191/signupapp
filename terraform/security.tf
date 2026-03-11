resource "aws_security_group" "frontend_sg" {

  name   = "frontend-sg"
  vpc_id = aws_vpc.webapp_vpc_staging.id

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["118.70.190.230/32"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_security_group" "backend_sg" {

  name   = "backend-sg"
  vpc_id = aws_vpc.webapp_vpc_staging.id

  ingress {

    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]

  }

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}