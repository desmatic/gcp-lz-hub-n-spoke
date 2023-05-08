resource "google_project_service" "project-development-vpc-service-dns" {
  project = var.pipeline_project_id
  service = "dns.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "development-vpc" {
  project     = var.pipeline_project_id
  name        = "development-vpc"
  dns_name    = "dev.gcp.${var.org_id}."
  description = "Development private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.development-vpc.network_id
    }
  }

  depends_on = [
    google_project_service.project-development-vpc-service-dns
  ]
}
