resource "google_project_service" "billing-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "billing-service-iam" {
  project = var.pipeline_project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "random_string" "project-billing-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-billing" {
  source = "terraform-google-modules/project-factory/google"

  name       = "organization-billing"
  project_id = "organization-billing-${random_string.project-billing-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.billing-finops.name

  auto_create_network            = false
  billing_account                = var.billing_account
  create_project_sa              = false
  enable_shared_vpc_host_project = false

  depends_on = [
    google_project_service.billing-service-cloudbilling,
    google_project_service.billing-service-iam,
  ]
}

resource "google_project_service" "billing-service-bigquery" {
  project = module.project-billing.project_id
  service = "bigquery.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }

  depends_on = [
    module.project-billing,
  ]
}

resource "google_project_service" "billing-service-bigquerydatatransfer" {
  project = module.project-billing.project_id
  service = "bigquerydatatransfer.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }

  depends_on = [
    module.project-billing,
  ]
}
