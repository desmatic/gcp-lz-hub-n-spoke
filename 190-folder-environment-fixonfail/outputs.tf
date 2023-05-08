output "fixonfail_folder_id" {
  description = "The fixonfail folder id"
  value       = google_folder.fixonfail.folder_id
}

output "fixonfail_network_self_link" {
  description = "The fixonfail network id"
  value       = module.fixonfail-vpc.network_self_link
}
