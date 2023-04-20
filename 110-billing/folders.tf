resource "google_folder" "billing" {
  display_name = "Billing"
  parent       = "folders/${var.landingzone_folder_id}"
}

resource "google_folder_iam_binding" "billing_admin" {
  folder = google_folder.billing.name
  role   = "roles/editor"
  members = [
    "group:gcp-billing-admins@${var.org_domain}",
  ]
}
