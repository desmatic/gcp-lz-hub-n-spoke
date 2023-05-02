resource "random_string" "project-fixonfail-suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_project_service" "fixonfail-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_dependent_services = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "project-fixonfail-vpc" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "fixonfail-vpc"
  project_id = "fixonfail-vpc-${random_string.project-fixonfail-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.fixonfail-infraops.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account

  depends_on = [
    google_project_service.fixonfail-service-cloudbilling
  ]
}

resource "random_string" "project-monitoring-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-fixonfail-monitoring" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "fixonfail-monitoring"
  project_id = "fixonfail-monitoring-${random_string.project-monitoring-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.fixonfail-sre.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-fixonfail-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.fixonfail-service-cloudbilling,
    module.project-fixonfail-vpc,
  ]
}

resource "random_string" "project-secrets-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-fixonfail-secrets" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "fixonfail-secrets"
  project_id = "fixonfail-secrets-${random_string.project-secrets-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.fixonfail-secops.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-fixonfail-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.fixonfail-service-cloudbilling,
    module.project-fixonfail-vpc,
  ]
}
