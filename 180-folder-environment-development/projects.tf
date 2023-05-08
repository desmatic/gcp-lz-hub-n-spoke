resource "random_string" "project-development-suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_project_service" "development-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_dependent_services = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "project-development-vpc" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "development-vpc"
  project_id = "development-vpc-${random_string.project-development-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.development-infraops.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account

  depends_on = [
    google_project_service.development-service-cloudbilling
  ]
}

resource "random_string" "project-monitoring-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-development-monitoring" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "development-monitoring"
  project_id = "development-monitoring-${random_string.project-monitoring-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.development-sre.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-development-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.development-service-cloudbilling,
    module.project-development-vpc,
  ]
}

resource "random_string" "project-secrets-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-development-secrets" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "development-secrets"
  project_id = "development-secrets-${random_string.project-secrets-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.development-secops.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-development-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.development-service-cloudbilling,
    module.project-development-vpc,
  ]
}
