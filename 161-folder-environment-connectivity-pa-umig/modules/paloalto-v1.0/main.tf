module "project-paloalto" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name              = "connectivity-paloalto"
  project_id        = "connectivity-paloalto"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = var.connectivity_infraops_folder_id

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = var.connectivity_vpc_project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}

#resource "google_monitoring_monitored_project" "project-paloalto-monitor" {
#  metrics_scope = join("", ["locations/global/metricsScopes/", var.spoke_monitoring_project_id])
#  name          = module.project-paloalto.project_id
#}

resource "google_service_account" "service_account" {
  account_id   = "connectivity-paloalto-umig"
  display_name = "connectivity-paloalto-umig"
  description  = "Service account for PaloAlto firewall compute instances"
  project      = module.project-paloalto.project_id
}

resource "google_project_iam_member" "service_account_bind" {
  for_each = toset([
    "roles/compute.networkViewer",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.accounts.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
  project = module.project-paloalto.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
