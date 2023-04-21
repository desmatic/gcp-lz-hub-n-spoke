output "sandbox_folder_id" {
  description = "The sandbox folder id"
  value       = google_folder.sandbox.folder_id
}

output "sandbox_network_self_link" {
  description = "The sandbox network id"
  value       = module.sandbox-vpc.network_self_link
}
