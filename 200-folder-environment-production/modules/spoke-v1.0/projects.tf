resource "random_string" "project-spoke-suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_project_service" "spoke-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_dependent_services = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "project-spoke-vpc" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "${local.spoke_name}-vpc"
  project_id = "${local.spoke_name}-vpc-${random_string.project-spoke-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.spoke-infraops.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
  ]

  depends_on = [
    google_project_service.spoke-service-cloudbilling
  ]
}

resource "random_string" "project-monitoring-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-spoke-monitoring" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "${local.spoke_name}-monitoring"
  project_id = "${local.spoke_name}-monitoring-${random_string.project-monitoring-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.spoke-sre.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-spoke-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.spoke-service-cloudbilling,
    module.project-spoke-vpc,
  ]
}

resource "random_string" "project-secrets-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-spoke-secrets" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "${local.spoke_name}-secrets"
  project_id = "${local.spoke_name}-secrets-${random_string.project-secrets-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.spoke-csoc.name

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = module.project-spoke-vpc.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]

  depends_on = [
    google_project_service.spoke-service-cloudbilling,
    module.project-spoke-vpc,
  ]
}
