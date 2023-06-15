resource "google_project_service" "project-spoke-vpc-service-dns" {
  project = var.pipeline_project_id
  service = "dns.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_dns_managed_zone" "spoke-vpc" {
  name        = "${local.spoke_name}-vpc"
  dns_name    = "${var.spoke_subdomain}.gcp.${var.org_domain}."
  description = "${var.spoke_name} private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.spoke-vpc.network_id
    }
  }

  depends_on = [
    google_project_service.project-spoke-vpc-service-dns
  ]
}
