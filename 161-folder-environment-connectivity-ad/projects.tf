resource "google_project_service" "connectivity-ad-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "random_string" "project-ad-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-connectivity-ad" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name       = "connectivity-ad"
  project_id = "connectivity-ad-${random_string.project-ad-suffix.result}"
  org_id     = var.org_id
  folder_id  = var.connectivity_infraops_folder_id

  auto_create_network = false
  billing_account     = var.billing_account
  create_project_sa   = false
  shared_vpc          = var.connectivity_vpc_project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iap.googleapis.com",
  ]

  depends_on = [
    google_project_service.connectivity-ad-service-cloudbilling,
  ]
}
