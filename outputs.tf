output "vpc1_id" {
  description = "The ID of the VPC in the first module"
  value       = module.vpc1.vpc_id
}

output "vpc2_id" {
  description = "The ID of the VPC in the second module"
  value       = module.vpc2.vpc_id
}

# Add any other outputs needed for your main configuration
