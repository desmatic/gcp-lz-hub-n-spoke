resource "google_folder" "environment" {
  display_name = "Environment"
  parent       = "folders/${var.landingzone_folder_id}"
}

resource "google_folder_iam_binding" "environment_admin" {
  folder = google_folder.environment.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}
