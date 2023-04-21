resource "google_project_service" "project-connectivity-vpc-service-dns" {
  project = module.project-connectivity-vpc.project_id
  service = "dns.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "connectivity-vpc" {
  project     = module.project-connectivity-vpc.project_id
  name        = "connectivity-vpc"
  dns_name    = "con.gcp.${var.org_id}."
  description = "Connectivity private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.connectivity-vpc.network_id
    }
  }

  depends_on = [
    google_project_service.project-connectivity-vpc-service-dns
  ]
}
