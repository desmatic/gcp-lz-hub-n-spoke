output "spoke_folder_name" {
  description = "The name of the spoke"
  value       = var.spoke_name
}

output "spoke_name" {
  description = "The name of the spoke"
  value       = local.spoke_name
}

output "spoke_domain" {
  description = "The doman name of the spoke"
  value       = "${var.spoke_subdomain}.gcp.${var.org_domain}."
}

output "spoke_folder_id" {
  description = "The spoke folder id"
  value       = google_folder.spoke.folder_id
}

output "spoke_vpc_project_id" {
  description = "The spoke VPC project id"
  value       = module.project-spoke-vpc.project_id
}

output "spoke_monitoring_project_id" {
  description = "The spoke monitoring project id"
  value       = module.project-spoke-monitoring.project_id
}

output "spoke_secrets_project_id" {
  description = "The spoke secrets project id"
  value       = module.project-spoke-secrets.project_id
}

output "spoke_network_self_link" {
  description = "The spoke network id"
  value       = module.spoke-vpc.network_self_link
}

output "spoke_subnetwork_primary" {
  description = "The primary subnetwork"
  value       = "${local.spoke_name}-primary-region"
}
