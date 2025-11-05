output "private_subnet_ids" {
  value       = aws_subnet.private-subnet[*].id
  description = "Private subnet IDs"
}

output "public_subnet_ids" {
  value       = aws_subnet.public-subnet[*].id
  description = "Public subnet IDs"
}

output "vpc_id" {
  value       = aws_vpc.my-vpc-eks.id
  description = "VPC id"
}
