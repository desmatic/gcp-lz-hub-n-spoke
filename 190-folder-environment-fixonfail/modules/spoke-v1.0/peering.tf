resource "google_compute_network_peering" "spoke-connectivity" {
  name         = "${local.spoke_name}-connectivity"
  network      = module.spoke-vpc.network_self_link
  peer_network = var.connectivity_network_self_link
}

resource "google_compute_network_peering" "connectivity-spoke" {
  name         = "connectivity-${local.spoke_name}"
  network      = var.connectivity_network_self_link
  peer_network = module.spoke-vpc.network_self_link
}

resource "google_dns_managed_zone" "spoke-connectivity" {
  project     = module.project-spoke-vpc.project_id
  name        = "${local.spoke_name}-connectivity"
  dns_name    = "snd.gcp.${var.org_domain}."
  description = "Peer ${var.spoke_name} zone with connectivity zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.connectivity_network_self_link
    }
  }

  peering_config {
    target_network {
      network_url = module.spoke-vpc.network_self_link
    }
  }
}

resource "google_dns_managed_zone" "connectvity-spoke" {
  project     = module.project-spoke-vpc.project_id
  name        = "connectivity-${local.spoke_name}"
  dns_name    = "con.gcp.${var.org_domain}."
  description = "Peer connectivity zone with ${var.spoke_name} zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.spoke-vpc.network_self_link
    }
  }

  peering_config {
    target_network {
      network_url = var.connectivity_network_self_link
    }
  }
}
