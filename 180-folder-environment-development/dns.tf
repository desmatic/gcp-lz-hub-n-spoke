resource "google_project_service" "project-development-vpc-service-dns" {
  project = module.project-development-vpc.project_id
  service = "dns.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "development-vpc" {
  project     = module.project-development-vpc.project_id
  name        = "development-vpc"
  dns_name    = "dev.gcp.${var.org_domain}."
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
