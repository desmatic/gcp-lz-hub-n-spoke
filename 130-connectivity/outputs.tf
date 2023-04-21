output "connectivity_folder_id" {
  description = "The connectivity folder id"
  value       = google_folder.connectivity.folder_id
}

output "connectivity_network_self_link" {
  description = "The connectivity network id"
  value       = module.vpc-connectivity.network_self_link
}
