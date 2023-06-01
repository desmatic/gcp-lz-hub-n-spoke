# https://cloud.google.com/dns/docs/zones/forwarding-zones#terraform
resource "google_dns_managed_zone" "connectivity-azure-ad" {
  project     = var.connectivity_vpc_project_id
  name        = "connectivity-azure-ad"
  dns_name    = "nationalgas.team."
  description = "Connectivity private DNS zone for azure ad"

  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.connectivity_network_self_link
    }
  }

  forwarding_config {
    target_name_servers {
      ipv4_address = "10.208.4.4"
    }
    target_name_servers {
      ipv4_address = "10.208.4.5"
    }
  }
}
