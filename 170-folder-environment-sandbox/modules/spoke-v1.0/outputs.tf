output "spoke_folder_id" {
  description = "The spoke folder id"
  value       = google_folder.spoke.folder_id
}

output "spoke_network_self_link" {
  description = "The spoke network id"
  value       = module.spoke-vpc.network_self_link
}
