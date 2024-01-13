output "vpc1_id" {
  description = "The ID of the VPC in the first module"
  value       = module.vpc1.vpc_id
}

output "vpc2_id" {
  description = "The ID of the VPC in the second module"
  value       = module.vpc2.vpc_id
}

output "service_network_id"{
    value = aws_vpclattice_service_network.service_network.id
}
output "service_network_arn"{
    value = aws_vpclattice_service_network.service_network.arn
}

output "lambda_service_id" {
    value = aws_vpclattice_service.lambda_service.id
}
output "lambda_service_arn" {
    value = aws_vpclattice_service.lambda_service.arn
}
output "https_listener_arn" {
    value = aws_vpclattice_listener.https_listener.arn
}

output "lambda_tg_arn" {
    value = aws_vpclattice_target_group.lambda_tg.arn
}
