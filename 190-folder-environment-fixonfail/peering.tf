resource "google_compute_network_peering" "fixonfail-connectivity" {
  name         = "fixonfail-connectivity"
  network      = module.fixonfail-vpc.network_self_link
  peer_network = var.connectivity_network_self_link
}

resource "google_compute_network_peering" "connectivity-fixonfail" {
  name         = "connectivity-fixonfail"
  network      = var.connectivity_network_self_link
  peer_network = module.fixonfail-vpc.network_self_link
}
