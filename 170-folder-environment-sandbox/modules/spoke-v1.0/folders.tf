resource "google_project_service" "spoke-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "spoke" {
  display_name = var.spoke_name
  parent       = var.environment_folder_id

  depends_on = [
    google_project_service.spoke-service-cloudresourcemanager
  ]
}

resource "google_folder" "spoke-dre" {
  display_name = "DRE"
  parent       = "folders/${google_folder.spoke.folder_id}"
}

resource "google_folder" "spoke-devops" {
  display_name = "DevOps"
  parent       = "folders/${google_folder.spoke.folder_id}"
}

resource "google_folder" "spoke-finops" {
  display_name = "FinOps"
  parent       = "folders/${google_folder.spoke.folder_id}"
}

resource "google_folder" "spoke-infraops" {
  display_name = "InfraOps"
  parent       = "folders/${google_folder.spoke.folder_id}"
}

resource "google_folder" "spoke-csoc" {
  display_name = "CSOC"
  parent       = "folders/${google_folder.spoke.folder_id}"
}

resource "google_folder" "spoke-sre" {
  display_name = "SRE"
  parent       = "folders/${google_folder.spoke.folder_id}"
}
