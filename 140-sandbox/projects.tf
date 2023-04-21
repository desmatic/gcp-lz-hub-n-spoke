resource "random_string" "project-sandbox-suffix" {
  length  = 5
  special = false
  upper   = false
}


resource "google_project_service" "sandbox-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "project-vpc-sandbox" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "vpc-sandbox"
  project_id = "vpc-sandbox-${random_string.project-sandbox-suffix.id}"
  org_id     = var.org_id
  folder_id  = google_folder.sandbox-infraops.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account

  depends_on = [
    google_project_service.sandbox-service-cloudbilling
  ]
}
