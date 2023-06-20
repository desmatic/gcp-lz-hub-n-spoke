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

  name              = "${var.spoke_subdomain}-vpc"
  project_id        = "${var.spoke_subdomain}-vpc"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.spoke-infraops.name

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

module "project-spoke-monitoring" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name              = "${var.spoke_subdomain}-monitoring"
  project_id        = "${var.spoke_subdomain}-monitoring"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.spoke-sre.name

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

resource "google_monitoring_monitored_project" "project-spoke-vpc-monitor" {
  metrics_scope = join("", ["locations/global/metricsScopes/", module.project-spoke-monitoring.project_id])
  name          = module.project-spoke-vpc.project_id
}

module "project-spoke-secrets" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name              = "${var.spoke_subdomain}-secrets"
  project_id        = "${var.spoke_subdomain}-secrets"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.spoke-csoc.name

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

resource "google_monitoring_monitored_project" "project-spoke-secrets-monitor" {
  metrics_scope = join("", ["locations/global/metricsScopes/", module.project-spoke-monitoring.project_id])
  name          = module.project-spoke-secrets.project_id
}
