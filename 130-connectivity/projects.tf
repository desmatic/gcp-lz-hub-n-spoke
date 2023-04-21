resource "random_string" "project-connectivity-suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_project_service" "connectivity-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "project-vpc-connectivity" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "vpc-connectivity"
  project_id = "vpc-connectivity-${random_string.project-connectivity-suffix.id}"
  org_id     = var.org_id
  folder_id  = google_folder.connectivity-infraops.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account

  depends_on = [
    google_project_service.connectivity-service-cloudbilling
  ]
}
