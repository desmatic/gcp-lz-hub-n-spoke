output "spoke_folder_name" {
  description = "Folder name for spoke"
  value       = module.spoke.spoke_folder_name
}

output "spoke_name" {
  description = "Lowercase name for spoke"
  value       = module.spoke.spoke_name
}

output "spoke_dns" {
  description = "Fully qualified domain name for spoke"
  value       = module.spoke.spoke_domain
}

output "spoke_folder_id" {
  description = "Folder ID for spoke"
  value       = module.spoke.spoke_folder_id
}

output "spoke_network_self_link" {
  description = "Network id for spoke"
  value       = module.spoke.spoke_network_self_link
}
