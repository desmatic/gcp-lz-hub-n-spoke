resource "google_project_service" "environment-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "environment" {
  display_name = "Environment"
  parent       = var.landingzone_folder_id

  depends_on = [
    google_project_service.environment-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "environment_admin" {
  folder = google_folder.environment.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}
