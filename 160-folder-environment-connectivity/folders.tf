resource "google_project_service" "connectivity-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "connectivity" {
  display_name = "Connectivity"
  parent       = var.environment_folder_id

  depends_on = [
    google_project_service.connectivity-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "connectivity_admin" {
  folder = google_folder.connectivity.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}

resource "google_folder" "connectivity-dre" {
  display_name = "DRE"
  parent       = "folders/${google_folder.connectivity.folder_id}"
}

resource "google_folder" "connectivity-devops" {
  display_name = "DevOps"
  parent       = "folders/${google_folder.connectivity.folder_id}"
}

resource "google_folder" "connectivity-finops" {
  display_name = "FinOps"
  parent       = "folders/${google_folder.connectivity.folder_id}"
}

resource "google_folder" "connectivity-infraops" {
  display_name = "InfraOps"
  parent       = "folders/${google_folder.connectivity.folder_id}"
}

resource "google_folder" "connectivity-secops" {
  display_name = "SecOps"
  parent       = "folders/${google_folder.connectivity.folder_id}"
}

resource "google_folder" "connectivity-sre" {
  display_name = "SRE"
  parent       = "folders/${google_folder.connectivity.folder_id}"
}
