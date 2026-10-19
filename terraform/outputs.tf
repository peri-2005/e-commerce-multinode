# variables.tf
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# outputs.tf
output "server_public_ip" {
  value       = aws_instance.ecommerce_host.public_ip
  description = "Access the app by browsing to this IP address"
}
