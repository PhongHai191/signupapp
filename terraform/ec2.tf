resource "aws_instance" "frontend_ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "signup-staging"
  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install docker -y

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user

              curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
              -o /usr/local/bin/docker-compose

              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = {
    Name = "frontend-ec2"
  }

}

resource "aws_instance" "backend_ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "signup-staging"
  subnet_id = aws_subnet.private_subnet.id

  vpc_security_group_ids = [
    aws_security_group.backend_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install docker -y

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user

              curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
              -o /usr/local/bin/docker-compose

              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = {
    Name = "backend-ec2"
  }

}