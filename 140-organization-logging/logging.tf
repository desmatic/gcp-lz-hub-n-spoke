resource "random_string" "logging-suffix" {
  length  = 5
  upper   = false
  special = false
}

module "destination" {
  source = "terraform-google-modules/log-export/google//modules/bigquery"

  project_id               = module.project-logging.project_id
  dataset_name             = "bq_org_${random_string.logging-suffix.result}"
  log_sink_writer_identity = module.log_export.writer_identity
}

module "log_export" {
  source = "terraform-google-modules/log-export/google"

  destination_uri        = module.destination.destination_uri
  log_sink_name          = "bigquery_org_${random_string.logging-suffix.result}"
  parent_resource_id     = var.landingzone_organization_deployment ? var.org_id : var.landingzone_folder_id
  parent_resource_type   = var.landingzone_organization_deployment ? "organization" : "folder"
  unique_writer_identity = true
}
