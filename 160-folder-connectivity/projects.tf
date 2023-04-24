resource "google_project_service" "connectivity-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "random_string" "project-connectivity-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-connectivity-vpc" {
  source = "terraform-google-modules/project-factory/google"

  name       = "connectivity-vpc"
  project_id = "connectivity-vpc-${random_string.project-connectivity-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.connectivity-infraops.name

  auto_create_network            = false
  billing_account                = var.billing_account
  create_project_sa              = false
  enable_shared_vpc_host_project = true

  depends_on = [
    google_project_service.connectivity-service-cloudbilling
  ]
}

resource "random_string" "project-monitoring-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-connectivity-monitoring" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "connectivity-monitoring"
  project_id = "connectivity-monitoring-${random_string.project-monitoring-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.connectivity-sre.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-connectivity-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.connectivity-service-cloudbilling
  ]
}

resource "random_string" "project-secrets-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-connectivity-secrets" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "connectivity-secrets"
  project_id = "connectivity-secrets-${random_string.project-secrets-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.connectivity-secops.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-connectivity-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.connectivity-service-cloudbilling
  ]
}
