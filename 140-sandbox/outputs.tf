output "sandbox_folder_id" {
  description = "The sandbox folder id"
  value       = google_folder.sandbox.folder_id
}

output "sandbox_network_self_link" {
  description = "The sandbox network id"
  value       = module.vpc-sandbox.network_self_link
}
