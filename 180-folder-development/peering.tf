resource "google_compute_network_peering" "development-connectivity" {
  name         = "development-connectivity"
  network      = module.development-vpc.network_self_link
  peer_network = var.connectivity_network_self_link
}

resource "google_compute_network_peering" "connectivity-development" {
  name         = "connectivity-development"
  network      = var.connectivity_network_self_link
  peer_network = module.development-vpc.network_self_link
}
