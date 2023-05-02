resource "google_project_service" "billing-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "billing" {
  display_name = "Billing"
  parent       = var.landingzone_folder_id

  depends_on = [
    google_project_service.billing-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "billing_admin" {
  folder = google_folder.billing.name
  role   = "roles/editor"
  members = [
    "group:gcp-billing-admins@${var.org_domain}",
  ]
}
