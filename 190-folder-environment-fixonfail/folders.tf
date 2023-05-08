resource "google_project_service" "fixonfail-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_folder" "fixonfail" {
  display_name = "Fixonfail"
  parent       = var.environment_folder_id

  depends_on = [
    google_project_service.fixonfail-service-cloudresourcemanager
  ]
}

resource "google_folder_iam_binding" "fixonfail_admin" {
  folder = google_folder.fixonfail.name
  role   = "roles/editor"
  members = [
    "group:gcp-network-admins@${var.org_domain}",
  ]
}

resource "google_folder" "fixonfail-dre" {
  display_name = "DRE"
  parent       = "folders/${google_folder.fixonfail.folder_id}"
}

resource "google_folder" "fixonfail-devops" {
  display_name = "DevOps"
  parent       = "folders/${google_folder.fixonfail.folder_id}"
}

resource "google_folder" "fixonfail-finops" {
  display_name = "FinOps"
  parent       = "folders/${google_folder.fixonfail.folder_id}"
}

resource "google_folder" "fixonfail-infraops" {
  display_name = "InfraOps"
  parent       = "folders/${google_folder.fixonfail.folder_id}"
}

resource "google_folder" "fixonfail-secops" {
  display_name = "SecOps"
  parent       = "folders/${google_folder.fixonfail.folder_id}"
}

resource "google_folder" "fixonfail-sre" {
  display_name = "SRE"
  parent       = "folders/${google_folder.fixonfail.folder_id}"
}
