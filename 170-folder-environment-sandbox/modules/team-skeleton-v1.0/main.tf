module "project-compute" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name              = "${var.spoke_name}-${var.team_name}-mig"
  project_id        = "${var.spoke_name}-${var.team_name}-mig"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = var.team_folder_id

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = var.spoke_vpc_project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}

resource "google_monitoring_monitored_project" "project-compute-monitor" {
  metrics_scope = join("", ["locations/global/metricsScopes/", var.spoke_monitoring_project_id])
  name          = module.project-compute.project_id
}

module "service_accounts" {
  source = "terraform-google-modules/service-accounts/google"
  #version       = "~> 3.0"

  project_id = module.project-compute.project_id
  prefix     = var.spoke_name
  names      = ["-${var.team_name}-mig"]
  project_roles = [
    "${module.project-compute.project_id}=>roles/viewer",
    "${module.project-compute.project_id}=>roles/storage.objectViewer",
  ]
}

module "instance_template" {
  source = "terraform-google-modules/vm/google//modules/instance_template"

  project_id         = module.project-compute.project_id
  subnetwork_project = var.spoke_vpc_project_id
  subnetwork         = var.spoke_subnetwork_primary
  region             = var.region_primary

  service_account = {
    email  = module.service_accounts.email
    scopes = ["cloud-platform"]
  }
  name_prefix = "${var.spoke_name}-${var.team_name}-mig"

  #  stack_type                   = "IPV4_ONLY"
  #  tags                         = var.tags
  #  labels                       = var.labels
}

module "mig_with_percent" {
  source = "terraform-google-modules/vm/google//modules/mig_with_percent"
  count = 0

  project_id                        = module.project-compute.project_id
  region                            = var.region_primary
  hostname                          = "${var.spoke_name}-${var.team_name}-mig"
  instance_template_initial_version = module.instance_template.self_link
  instance_template_next_version    = module.instance_template.self_link
  next_version_percent              = 50
  autoscaling_cpu = [{
    target            = 0.4
    predictive_method = "OPTIMIZE_AVAILABILITY"
  }]
}
