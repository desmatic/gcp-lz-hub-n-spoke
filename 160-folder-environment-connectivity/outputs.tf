output "connectivity_infraops_folder_id" {
  description = "The connectivity infraops folder id"
  value       = google_folder.connectivity-infraops.folder_id
}

output "connectivity_network_self_link" {
  description = "The connectivity network id"
  value       = module.connectivity-vpc.network_self_link
}

output "connectivity_vpc_project_id" {
  value = module.project-connectivity-vpc.project_id
}

output "connectivity_primary_region_subnets_self_link" {
  value = module.connectivity-vpc.subnets_self_links[0]
}

output "connectivity_vpc_dns_managed_zone" {
  value = google_dns_managed_zone.connectivity-vpc.name
}

output "connectivity_vpc_dns_name" {
  value = google_dns_managed_zone.connectivity-vpc.dns_name
}