output "folder_connectivity" {
  description = "The connectivity folder id"
  value       = google_folder.connectivity.folder_id
}

output "network_connectivity" {
  description = "The connectivity network id"
  value       = module.vpc-connectivity.network_self_link
}
