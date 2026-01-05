#output "project_id" {
#  value       = var.project_id
#  description = "The project to run tests against"
#}


output "project_id" {
  value       = module.project-factory.project_id
  description = "The ID of the created project"
}

output "vpc" {
  value       = module.vpc
  description = "The network info"
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "subnets" {
  value       = module.vpc.subnets_self_links
  description = "The shared VPC subets"
}
