locals {
  network_interface = google_compute_instance.instance.network_interface[0]
  instance_nat_ip   = length(local.network_interface.access_config) > 0 ? local.network_interface.access_config[0].nat_ip : null
  instance_ip       = coalesce(local.instance_nat_ip, local.network_interface.network_ip)
}

output "instance_self_link" {
  value       = google_compute_instance.instance.self_link
}

output "instance_zone" {
  value       = var.zone
}

output "instance_machine_type" {
  value       = var.machine_type
}

output "instance_nat_ip" {
  value       = local.instance_nat_ip
}

output "instance_network" {
  value       = var.networks[0]
}

output "project_id" {
  value = google_project.this.project_id
}

output "project_number" {
  value = google_project.this.number
}

output "enabled_services" {
  value = sort(tolist(var.enabled_services))
}

# Use this as a depends_on target for any resources that require enabled APIs.
output "services_ready_dependency" {
  value = time_sleep.after_service_enablement.id
}

