resource "google_project_service" "logging-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "logging" {
  display_name = "Logging"
  parent       = var.landingzone_folder_id

  depends_on = [
    google_project_service.logging-service-cloudresourcemanager
  ]
}

resource "google_folder" "logging-csoc" {
  display_name = "CSOC"
  parent       = "folders/${google_folder.logging.folder_id}"
}

resource "google_folder_iam_binding" "logging_admin" {
  folder = google_folder.logging-csoc.name
  role   = "roles/editor"
  members = [
    "group:gcp-security-admins@${var.org_domain}",
  ]
}
