resource "google_compute_network_peering" "sandbox-connectivity" {
  name         = "sandbox-connectivity"
  network      = module.vpc-sandbox.network_self_link
  peer_network = var.connectivity_network_self_link
}

resource "google_compute_network_peering" "connectivity-sandbox" {
  name         = "connectivity-sandbox"
  network      = var.connectivity_network_self_link
  peer_network = module.vpc-sandbox.network_self_link
}
