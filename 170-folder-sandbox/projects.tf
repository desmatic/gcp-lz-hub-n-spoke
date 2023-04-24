resource "random_string" "project-sandbox-suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_project_service" "sandbox-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_dependent_services = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "project-sandbox-vpc" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "sandbox-vpc"
  project_id = "sandbox-vpc-${random_string.project-sandbox-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.sandbox-infraops.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account

  depends_on = [
    google_project_service.sandbox-service-cloudbilling
  ]
}

resource "random_string" "project-monitoring-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-sandbox-monitoring" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "sandbox-monitoring"
  project_id = "sandbox-monitoring-${random_string.project-monitoring-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.sandbox-sre.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-sandbox-vpc.project_id

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

module "project-sandbox-secrets" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "sandbox-secrets"
  project_id = "sandbox-secrets-${random_string.project-secrets-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.sandbox-secops.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-sandbox-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.connectivity-service-cloudbilling
  ]
}