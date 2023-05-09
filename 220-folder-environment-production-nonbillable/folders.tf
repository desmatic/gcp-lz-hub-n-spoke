resource "google_project_service" "sandbox-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "sandbox" {
  display_name = "Sandbox"
  parent       = var.production_folder_id

  depends_on = [
    google_project_service.sandbox-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "sandbox_admin" {
  folder = google_folder.sandbox.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}

resource "google_folder" "sandbox-dre" {
  display_name = "DRE"
  parent       = "folders/${google_folder.sandbox.folder_id}"
}

resource "google_folder" "sandbox-devops" {
  display_name = "DevOps"
  parent       = "folders/${google_folder.sandbox.folder_id}"
}

resource "google_folder" "sandbox-finops" {
  display_name = "FinOps"
  parent       = "folders/${google_folder.sandbox.folder_id}"
}

resource "google_folder" "sandbox-infraops" {
  display_name = "InfraOps"
  parent       = "folders/${google_folder.sandbox.folder_id}"
}

resource "google_folder" "sandbox-secops" {
  display_name = "SecOps"
  parent       = "folders/${google_folder.sandbox.folder_id}"
}

resource "google_folder" "sandbox-sre" {
  display_name = "SRE"
  parent       = "folders/${google_folder.sandbox.folder_id}"
}