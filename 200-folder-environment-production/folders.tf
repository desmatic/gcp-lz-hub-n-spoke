resource "google_project_service" "production-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "production" {
  display_name = "production"
  parent       = var.environment_folder_id

  depends_on = [
    google_project_service.production-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "production_admin" {
  folder = google_folder.production.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}
