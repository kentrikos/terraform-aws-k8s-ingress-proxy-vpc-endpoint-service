output "vpces_service_name" {
  description = "Name of VPC Endpoint Service"
  value       = aws_vpc_endpoint_service.k8s_ingress.service_name
}

output "vpces_base_endpoint_dns_names" {
  description = "The DNS names for the VPC endpoint service"
  value       = aws_vpc_endpoint_service.k8s_ingress.base_endpoint_dns_names
}
