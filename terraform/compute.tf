resource "aws_instance" "app_server" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2023 AMI
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker
              
              # Authenticate to AWS ECR if using private images
              # aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_repo_url}
              
              # Deploy backend and frontend microservices
              docker run -d --name user-service -p 3001:3000 my-repo/user-service:latest
              docker run -d --name products-service -p 3002:3000 my-repo/products-service:latest
              docker run -d --name orders-service -p 3003:3000 my-repo/orders-service:latest
              docker run -d --name cart-service -p 3004:3000 my-repo/cart-service:latest
              docker run -d --name frontend -p 80:80 my-repo/frontend:latest
              EOF

  tags = {
    Name = "ecommerce-app-server"
  }
}
