resource "google_compute_network_peering" "sandbox-connectivity" {
  name         = "sandbox-connectivity"
  network      = module.sandbox-vpc.network_self_link
  peer_network = var.connectivity_network_self_link
}

resource "google_compute_network_peering" "connectivity-sandbox" {
  name         = "connectivity-sandbox"
  network      = var.connectivity_network_self_link
  peer_network = module.sandbox-vpc.network_self_link
}

resource "google_dns_managed_zone" "sandbox-connectivity" {
  project     = module.project-sandbox-vpc.project_id
  name        = "sandbox-connectivity"
  dns_name    = "snd.gcp.${var.org_domain}."
  description = "Peer sandbox zone with connectivity zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.connectivity_network_self_link
    }
  }

  peering_config {
    target_network {
      network_url = module.sandbox-vpc.network_self_link
    }
  }
}

resource "google_dns_managed_zone" "connectvity-sandbox" {
  project     = module.project-sandbox-vpc.project_id
  name        = "connectivity-sandbox"
  dns_name    = "con.gcp.${var.org_domain}."
  description = "Peer connectivity zone with sandbox zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.sandbox-vpc.network_self_link
    }
  }

  peering_config {
    target_network {
      network_url = var.connectivity_network_self_link
    }
  }
}
