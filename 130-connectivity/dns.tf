resource "google_project_service" "project-vpc-connectivity-service-dns" {
  project = module.project-vpc-connectivity.project_id
  service = "dns.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "vpc-connectivity" {
  project     = module.project-vpc-connectivity.project_id
  name        = "vpc-connectivity"
  dns_name    = "con.gcp.${var.org_id}."
  description = "Connectivity private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.vpc-connectivity.network_id
    }
  }

  depends_on = [
    google_project_service.project-vpc-connectivity-service-dns
  ]
}
