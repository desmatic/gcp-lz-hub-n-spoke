resource "google_project_service" "project-sandbox-vpc-service-compute" {
  project = var.pipeline_project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "project-sandbox-vpc-service-iam" {
  project = var.pipeline_project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "sandbox-vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  project_id      = module.project-sandbox-vpc.project_id
  network_name    = "sandbox"
  routing_mode    = "GLOBAL"
  shared_vpc_host = true

  subnets = [
    {
      subnet_name               = "sandbox-primary-region"
      subnet_ip                 = cidrsubnet(var.landingzone_network, 6, 8)
      subnet_region             = var.region_primary
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.1"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      stack                     = "IPV4_ONLY" # "IPV4_IPV6"
      #ipv6_type                 = "EXTERNAL"
    },
    {
      subnet_name               = "sandbox-secondary-region"
      subnet_ip                 = cidrsubnet(var.landingzone_network, 6, 12)
      subnet_region             = var.region_secondary
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.1"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      stack                     = "IPV4_ONLY" # "IPV4_IPV6"
      #ipv6_type                 = "EXTERNAL"
    },
  ]

  secondary_ranges = {
    sandbox-primary-region   = []
    sandbox-secondary-region = []
  }

  routes = [
    {
      name              = "rt-sandbox-vpc-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      priority          = "1000"
      next_hop_internet = "true"
      tags              = "egress-internet"
    },
  ]

  depends_on = [
    google_project_service.project-sandbox-vpc-service-compute,
    google_project_service.project-sandbox-vpc-service-iam,
  ]
}

resource "google_compute_firewall" "sandbox-vpc-allow-iap-ssh" {
  name      = "sandbox-vpc-allow-iap-ssh"
  network   = module.sandbox-vpc.network_name
  project   = module.project-sandbox-vpc.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}

resource "google_compute_firewall" "sandbox-vpc-allow-icmp" {
  name      = "sandbox-vpc-allow-icmp"
  network   = module.sandbox-vpc.network_name
  project   = module.project-sandbox-vpc.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.128.0.0/9",
  ]
}
# NAT Router and config
resource "google_compute_router" "cr-sandbox-vpc-sb0-primary-router" {
  name    = "cr-sandbox-vpc-sb0-primary-router"
  project = module.project-sandbox-vpc.project_id
  region  = var.region_primary
  network = module.sandbox-vpc.network_self_link
}

resource "google_compute_router_nat" "rn-sandbox-vpc-sb0-primary-egress" {
  name                               = "rn-sandbox-vpc-sb0-primary-egress"
  project                            = module.project-sandbox-vpc.project_id
  router                             = google_compute_router.cr-sandbox-vpc-sb0-primary-router.name
  region                             = var.region_primary
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-sandbox-vpc-sb0-primary-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-sandbox-vpc-sb0-primary-1" {
  project = module.project-sandbox-vpc.project_id
  name    = "ca-sandbox-vpc-sb0-primary-1"
  region  = var.region_primary
}

resource "google_compute_router" "cr-sandbox-vpc-sb1-secondary-router" {
  name    = "cr-sandbox-vpc-sb1-secondary-router"
  project = module.project-sandbox-vpc.project_id
  region  = var.region_secondary
  network = module.sandbox-vpc.network_self_link
}

resource "google_compute_router_nat" "rn-sandbox-vpc-sb1-secondary-egress" {
  name                               = "rn-sandbox-vpc-sb1-secondary-egress"
  project                            = module.project-sandbox-vpc.project_id
  router                             = google_compute_router.cr-sandbox-vpc-sb1-secondary-router.name
  region                             = var.region_secondary
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-sandbox-vpc-sb1-secondary-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-sandbox-vpc-sb1-secondary-1" {
  project = module.project-sandbox-vpc.project_id
  name    = "ca-sandbox-vpc-sb1-secondary-1"
  region  = var.region_secondary
}
