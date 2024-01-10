output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_az1_id" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.private_subnet_az1.id
}
output "private_subnet_az2_id" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.private_subnet_az2.id
}

