resource "google_project_service" "project-vpc-sandbox-service-dns" {
  project = module.project-vpc-sandbox.project_id
  service = "dns.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "vpc-sandbox" {
  project     = module.project-vpc-sandbox.project_id
  name        = "vpc-sandbox"
  dns_name    = "snd.gcp.${var.org_id}."
  description = "Sandbox private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.vpc-sandbox.network_id
    }
  }

  depends_on = [
    google_project_service.project-vpc-sandbox-service-dns
  ]
}
