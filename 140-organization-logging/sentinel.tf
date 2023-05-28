resource "google_project_service" "project-logging-service-logging" {
  project = module.project-logging.project_id
  service = "logging.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "project-logging-service-pubsub" {
  project = module.project-logging.project_id
  service = "pubsub.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "project-logging-service-iamcredentials" {
  project = module.project-logging.project_id
  service = "iamcredentials.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "sentinel_log_export" {
  source          = "terraform-google-modules/log-export/google"
  destination_uri = module.sentinel_destination.destination_uri
  #filter                 = "severity >= ERROR"
  log_sink_name          = "organization-sentinel"
  parent_resource_id     = var.landingzone_organization_deployment ? var.org_id : var.landingzone_folder_id
  parent_resource_type   = var.landingzone_organization_deployment ? "organization" : "folder"
  unique_writer_identity = true
  include_children       = true
}

module "sentinel_destination" {
  source                   = "terraform-google-modules/log-export/google//modules/pubsub"
  project_id               = module.project-logging.project_id
  topic_name               = var.sentinel_topic_name
  log_sink_writer_identity = module.sentinel_log_export.writer_identity
  create_subscriber        = true
  depends_on = [
    module.project-logging,
  ]
}
