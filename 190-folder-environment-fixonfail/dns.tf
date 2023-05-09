resource "google_project_service" "project-fixonfail-vpc-service-dns" {
  project = var.pipeline_project_id
  service = "dns.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "fixonfail-vpc" {
  project     = var.pipeline_project_id
  name        = "fixonfail-vpc"
  dns_name    = "fof.gcp.${var.org_id}."
  description = "Fixonfail private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.fixonfail-vpc.network_id
    }
  }

  depends_on = [
    google_project_service.project-fixonfail-vpc-service-dns
  ]
}