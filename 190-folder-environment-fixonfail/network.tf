resource "google_project_service" "project-fixonfail-vpc-service-compute" {
  project = var.pipeline_project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "project-fixonfail-vpc-service-iam" {
  project = var.pipeline_project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "fixonfail-vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  project_id      = module.project-fixonfail-vpc.project_id
  network_name    = "fixonfail"
  routing_mode    = "GLOBAL"
  shared_vpc_host = true

  subnets = [
    {
      subnet_name               = "fixonfail-primary-region"
      subnet_ip                 = cidrsubnet(var.landingzone_network, 6, 24)
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
      subnet_name               = "fixonfail-secondary-region"
      subnet_ip                 = cidrsubnet(var.landingzone_network, 6, 28)
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
    fixonfail-primary-region   = []
    fixonfail-secondary-region = []
  }

  routes = [
    {
      name              = "rt-fixonfail-vpc-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      priority          = "1000"
      next_hop_internet = "true"
      tags              = "egress-internet"
    },
  ]

  depends_on = [
    google_project_service.project-fixonfail-vpc-service-compute,
    google_project_service.project-fixonfail-vpc-service-iam,
  ]
}

resource "google_compute_firewall" "fixonfail-vpc-allow-iap-ssh" {
  name      = "fixonfail-vpc-allow-iap-ssh"
  network   = module.fixonfail-vpc.network_name
  project   = module.project-fixonfail-vpc.project_id
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

resource "google_compute_firewall" "fixonfail-vpc-allow-icmp" {
  name      = "fixonfail-vpc-allow-icmp"
  network   = module.fixonfail-vpc.network_name
  project   = module.project-fixonfail-vpc.project_id
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
resource "google_compute_router" "cr-fixonfail-vpc-sb0-primary-router" {
  name    = "cr-fixonfail-vpc-sb0-primary-router"
  project = module.project-fixonfail-vpc.project_id
  region  = var.region_primary
  network = module.fixonfail-vpc.network_self_link
}

resource "google_compute_router_nat" "rn-fixonfail-vpc-sb0-primary-egress" {
  name                               = "rn-fixonfail-vpc-sb0-primary-egress"
  project                            = module.project-fixonfail-vpc.project_id
  router                             = google_compute_router.cr-fixonfail-vpc-sb0-primary-router.name
  region                             = var.region_primary
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-fixonfail-vpc-sb0-primary-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-fixonfail-vpc-sb0-primary-1" {
  project = module.project-fixonfail-vpc.project_id
  name    = "ca-fixonfail-vpc-sb0-primary-1"
  region  = var.region_primary
}

resource "google_compute_router" "cr-fixonfail-vpc-sb1-secondary-router" {
  name    = "cr-fixonfail-vpc-sb1-secondary-router"
  project = module.project-fixonfail-vpc.project_id
  region  = var.region_secondary
  network = module.fixonfail-vpc.network_self_link
}

resource "google_compute_router_nat" "rn-fixonfail-vpc-sb1-secondary-egress" {
  name                               = "rn-fixonfail-vpc-sb1-secondary-egress"
  project                            = module.project-fixonfail-vpc.project_id
  router                             = google_compute_router.cr-fixonfail-vpc-sb1-secondary-router.name
  region                             = var.region_secondary
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-fixonfail-vpc-sb1-secondary-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-fixonfail-vpc-sb1-secondary-1" {
  project = module.project-fixonfail-vpc.project_id
  name    = "ca-fixonfail-vpc-sb1-secondary-1"
  region  = var.region_secondary
}
