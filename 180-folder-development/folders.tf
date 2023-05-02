resource "google_project_service" "development-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "development" {
  display_name = "Development"
  parent       = var.environment_folder_id

  depends_on = [
    google_project_service.development-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "development_admin" {
  folder = google_folder.development.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}

resource "google_folder" "development-dre" {
  display_name = "DRE"
  parent       = "folders/${google_folder.development.folder_id}"
}

resource "google_folder" "development-devops" {
  display_name = "DevOps"
  parent       = "folders/${google_folder.development.folder_id}"
}

resource "google_folder" "development-finops" {
  display_name = "FinOps"
  parent       = "folders/${google_folder.development.folder_id}"
}

resource "google_folder" "development-infraops" {
  display_name = "InfraOps"
  parent       = "folders/${google_folder.development.folder_id}"
}

resource "google_folder" "development-secops" {
  display_name = "SecOps"
  parent       = "folders/${google_folder.development.folder_id}"
}

resource "google_folder" "development-sre" {
  display_name = "SRE"
  parent       = "folders/${google_folder.development.folder_id}"
}
