# https://cloud.google.com/architecture/deploy-an-active-directory-forest-on-compute-engine

resource "google_service_account" "ad-service-account" {
  account_id   = "ad-domaincontroller"
  display_name = "Active Directory domain controllers service account"
  project      = module.project-connectivity-ad.project_id
}

resource "google_compute_firewall" "allow-dns-ingress-from-clouddns" {
  name    = "allow-dns-ingress-from-clouddns"
  network = var.connectivity_network_self_link
  project = var.connectivity_vpc_project_id

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  source_ranges = [
    "35.199.192.0/19",
  ]

  target_tags = [
    "ad-domaincontroller",
  ]
}

resource "google_compute_firewall" "allow-replication-between-addc" {
  name    = "allow-replication-between-addc"
  network = var.connectivity_network_self_link
  project = var.connectivity_vpc_project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "53",
      "88",
      "135",
      "389",
      "445",
      "636",
      "3389",
      "49152-65535",
    ]
  }

  allow {
    protocol = "udp"
    ports = [
      "53",
      "88",
      "123",
      "389",
      "445",
    ]
  }

  source_tags = [
    "ad-domaincontroller",
  ]

  # azure ad controllers
  source_ranges = [
    var.azure_primary_ad_network,
    var.azure_secondary_ad_network,
  ]

  target_tags = [
    "ad-domaincontroller",
  ]
}

resource "google_compute_firewall" "allow-logon-ingress-to-addc" {
  name    = "allow-logon-ingress-to-addc"
  network = var.connectivity_network_self_link
  project = var.connectivity_vpc_project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "53",
      "88",
      "135",
      "389",
      "445",
      "464",
      "636",
      "3268",
      "9389",
      "49152-65535",
    ]
  }

  allow {
    protocol = "udp"
    ports = [
      "53",
      "88",
      "123",
      "389",
      "445",
      "464",
      "3268",
    ]
  }

  source_ranges = [
    var.landingzone_network
  ]

  target_tags = [
    "ad-domaincontroller",
  ]
}

resource "google_compute_address" "ad-primary-ip" {
  name         = "ad-primary"
  address      = "10.210.0.4"
  address_type = "INTERNAL"
  region       = var.region_primary
  subnetwork   = var.connectivity_primary_region_subnets_self_link
  project      = module.project-connectivity-ad.project_id
}

resource "google_compute_disk" "ad-primary-data-disk" {
  name    = "gcpeu2addcp05ntds"
  type    = "pd-ssd"
  size    = "32"
  zone    = var.zone_primary
  project = module.project-connectivity-ad.project_id
  labels = {
    environment = "connectivity"
  }
}

resource "google_compute_instance" "ad-primary" {
  name         = "gcpeu2addcp05"
  machine_type = "n2-standard-8"
  zone         = var.zone_primary
  project      = module.project-connectivity-ad.project_id
  deletion_protection = true

  tags = [
    "ad-domaincontroller"
  ]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022-core"
      size  = "64"
      type  = "pd-ssd"
    }
    auto_delete = false
  }

  attached_disk {
    source = google_compute_disk.ad-primary-data-disk.self_link
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.ad-service-account.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = var.connectivity_primary_region_subnets_self_link
    network_ip = google_compute_address.ad-primary-ip.address
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

resource "google_compute_address" "ad-secondary-ip" {
  name         = "ad-secondary"
  address      = "10.210.0.8"
  address_type = "INTERNAL"
  region       = var.region_primary
  subnetwork   = var.connectivity_primary_region_subnets_self_link
  project      = module.project-connectivity-ad.project_id
}

resource "google_compute_disk" "ad-secondary-data-disk" {
  name    = "gcpeu2addcp06ntds"
  type    = "pd-ssd"
  size    = "32"
  zone    = var.zone_secondary
  project = module.project-connectivity-ad.project_id
  labels = {
    environment = "connectivity"
  }
}

resource "google_compute_instance" "ad-secondary" {
  name         = "gcpeu2addcp06"
  machine_type = "n2-standard-8"
  zone         = var.zone_secondary
  project      = module.project-connectivity-ad.project_id
  deletion_protection = true

  tags = [
    "ad-domaincontroller"
  ]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022-core"
      size  = "64"
      type  = "pd-ssd"
    }
    auto_delete = false
  }

  attached_disk {
    source = google_compute_disk.ad-secondary-data-disk.self_link
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.ad-service-account.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = var.connectivity_primary_region_subnets_self_link
    network_ip = google_compute_address.ad-secondary-ip.address
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}
