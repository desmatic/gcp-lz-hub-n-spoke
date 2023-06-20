resource "google_project_service" "project-spoke-vpc-service-compute" {
  project = var.pipeline_project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "project-spoke-vpc-service-iam" {
  project = var.pipeline_project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "spoke-vpc" {
  source = "terraform-google-modules/network/google"

  project_id      = module.project-spoke-vpc.project_id
  network_name    = var.spoke_subdomain
  routing_mode    = "GLOBAL"
  shared_vpc_host = true

  subnets = [
    {
      subnet_name               = "${var.spoke_subdomain}-primary-region"
      subnet_ip                 = cidrsubnet(var.spoke_vpc_primary_prefix, var.spoke_vpc_primary_newbits, var.spoke_vpc_primary_netnum)
      subnet_region             = var.region_primary
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.1"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      stack                     = "IPV4_ONLY" # "IPV4_IPV6"
      #ipv6_type                 = "EXTERNAL"
    },
  ]

  #  secondary_ranges = {
  #    ${var.spoke_subdomain}-primary-region-containers   = []
  #  }

  routes = [
    {
      name              = "rt-spoke-vpc-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      priority          = "1000"
      next_hop_internet = "true"
      tags              = "egress-internet"
    },
  ]

  depends_on = [
    google_project_service.project-spoke-vpc-service-compute,
    google_project_service.project-spoke-vpc-service-iam,
  ]
}

resource "google_compute_subnetwork" "spoke-vpc-connect-primary-region" {
  provider = google-beta

  name          = "${var.spoke_subdomain}-connect-primary-region"
  project       = module.project-spoke-vpc.project_id
  ip_cidr_range = cidrsubnet(var.spoke_vpc_primary_prefix, var.spoke_vpc_primary_connect_newbits, var.spoke_vpc_primary_connect_netnum)
  region        = var.region_primary
  purpose       = "PRIVATE_SERVICE_CONNECT"
  role          = "ACTIVE"
  network       = module.spoke-vpc.network_id
}

resource "google_compute_subnetwork" "spoke-vpc-proxy-primary-region" {
  provider = google-beta

  name          = "${var.spoke_subdomain}-proxy-primary-region"
  project       = module.project-spoke-vpc.project_id
  ip_cidr_range = cidrsubnet(var.spoke_vpc_primary_prefix, var.spoke_vpc_primary_proxy_newbits, var.spoke_vpc_primary_proxy_netnum)
  region        = var.region_primary
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = module.spoke-vpc.network_id
}

resource "google_compute_firewall" "spoke-vpc-allow-iap-ssh" {
  name      = "${var.spoke_subdomain}-vpc-allow-iap-ssh"
  network   = module.spoke-vpc.network_name
  project   = module.project-spoke-vpc.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",
    ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}

resource "google_compute_firewall" "spoke-vpc-allow-iap-rdp" {
  name      = "${var.spoke_subdomain}-vpc-allow-iap-rdp"
  network   = module.spoke-vpc.network_name
  project   = module.project-spoke-vpc.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports = [
      "3389",
    ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}

resource "google_compute_firewall" "spoke-vpc-allow-icmp" {
  name      = "${var.spoke_subdomain}-vpc-allow-icmp"
  network   = module.spoke-vpc.network_name
  project   = module.project-spoke-vpc.project_id
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
resource "google_compute_router" "cr-spoke-vpc-sb0-primary-router" {
  name    = "cr-${var.spoke_subdomain}-vpc-sb0-primary-router"
  project = module.project-spoke-vpc.project_id
  region  = var.region_primary
  network = module.spoke-vpc.network_self_link
}

resource "google_compute_router_nat" "rn-spoke-vpc-sb0-primary-egress" {
  name                               = "rn-${var.spoke_subdomain}-vpc-sb0-primary-egress"
  project                            = module.project-spoke-vpc.project_id
  router                             = google_compute_router.cr-spoke-vpc-sb0-primary-router.name
  region                             = var.region_primary
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-spoke-vpc-sb0-primary-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-spoke-vpc-sb0-primary-1" {
  project = module.project-spoke-vpc.project_id
  name    = "ca-${var.spoke_subdomain}-vpc-sb0-primary-1"
  region  = var.region_primary
}
