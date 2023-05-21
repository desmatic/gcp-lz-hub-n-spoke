resource "google_project_service" "logging-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "random_string" "project-logging-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-logging" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "organization-logging"
  project_id = "organization-logging-${random_string.project-logging-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.logging-csoc.name

  auto_create_network            = false
  billing_account                = var.billing_account
  create_project_sa              = false
  enable_shared_vpc_host_project = false

  depends_on = [
    google_project_service.logging-service-cloudbilling
  ]
}
