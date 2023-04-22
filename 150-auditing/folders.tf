resource "google_project_service" "auditing-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "auditing" {
  display_name = "Auditing"
  parent       = "folders/${var.landingzone_folder_id}"

  depends_on = [
    google_project_service.auditing-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "auditing_admin" {
  folder = google_folder.auditing.name
  role   = "roles/editor"
  members = [
    "group:gcp-security-admins@${var.org_domain}",
  ]
}
