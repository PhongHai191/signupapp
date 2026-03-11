output "frontend_public_ip" {

  value = aws_instance.frontend_ec2.public_ip

}

output "backend_private_ip" {

  value = aws_instance.backend_ec2.private_ip

}