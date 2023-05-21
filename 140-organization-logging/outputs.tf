output "logging_folder_id" {
  description = "The logging folder id"
  value       = google_folder.logging.folder_id
}

output "logging_project_id" {
  value = module.project-logging.project_id
}

output "logging_project_number" {
  value = module.project-logging.project_number
}
