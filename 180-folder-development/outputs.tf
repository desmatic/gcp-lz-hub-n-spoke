output "development_folder_id" {
  description = "The development folder id"
  value       = google_folder.development.folder_id
}

output "development_network_self_link" {
  description = "The development network id"
  value       = module.development-vpc.network_self_link
}
