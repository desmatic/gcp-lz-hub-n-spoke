# General
project     = "desjones-paloalto"
region      = "europe-west2" # Modify this value as per deployment requirements
name_prefix = ""

# Service accounts

service_accounts = {
  sa-vmseries-01 = {
    service_account_id = "sa-vmseries-01"
    display_name       = "VM-Series SA"
    roles = [
      "roles/compute.networkViewer",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
      "roles/monitoring.viewer",
      "roles/viewer"
    ]
  },
}

# VPC
networks = {
  mgmt = {
    create_network                  = true
    create_subnetwork               = true
    name                            = "fw-mgmt-vpc"
    subnetwork_name                 = "fw-mgmt-sub"
    ip_cidr_range                   = "10.210.12.0/27"
    allowed_sources                 = ["0.0.0.0/0"]
    delete_default_routes_on_create = false
    allowed_protocol                = "all"
    allowed_ports                   = []
  },
  untrust = {
    create_network                  = true
    create_subnetwork               = true
    name                            = "fw-untrust-vpc"
    subnetwork_name                 = "fw-untrust-sub"
    ip_cidr_range                   = "10.210.12.128/27"
    allowed_sources                 = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
    delete_default_routes_on_create = false
    allowed_protocol                = "all"
    allowed_ports                   = []
  },
  trust = {
    create_network                  = true
    create_subnetwork               = true
    name                            = "fw-trust-vpc"
    subnetwork_name                 = "fw-trust-sub"
    ip_cidr_range                   = "10.210.0.0/22"
    allowed_sources                 = ["10.210.0.0/16", "35.191.0.0/16", "130.211.0.0/22"]
    delete_default_routes_on_create = true
    allowed_protocol                = "all"
    allowed_ports                   = []
  },
}

# Static routes
routes = {
  fw-default-trust = {
    name              = "fw-default-trust"
    destination_range = "0.0.0.0/0"
    network           = "fw-trust-vpc"
    lb_internal_key   = "internal-lb"
  }
}

# VM-Series
vmseries_common = {
  ssh_keys            = "admin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDibRW/ZMWZG7iXLg4DRLqsO6VH9IONTaEMMzuGX1/Er+e7spebVBwc4Ely3OnHzjjw/sQLoxxo8aNYAXj+lUbeh0RBT+655nNUpc93mhFgWhZ1VmBU3EM9uU7nVv1v5yfp0s9lGhA/2lMoKdgT2u9SIxBPULZHfJA8hJ6JICk3JBgozj3hsWoM13muYIR0+q108Aaj279ivLJ4cDn+SlDwIzPwrXaLP2SHUsKr5LjfMCagtmalxmZGjVRDpHFl2EPiIAwanjoCX3JoiwgKqP50nmKzSD5m1eICbJupqOLPu1FkYtlPJSXIbV0gFY/dH81C5mByA1072ornE5ERA00L"
  vmseries_image      = "vmseries-flex-byol-1023"
  machine_type        = "n2-standard-4"
  min_cpu_platform    = "Intel Cascade Lake"
  service_account_key = "sa-vmseries-01"
  bootstrap_options = {
    type                = "dhcp-client"
    mgmt-interface-swap = "enable"
  }
}

vmseries = {
  fw-vmseries-01 = {
    name = "fw-vmseries-01"
    zone = "europe-west2-a"
    tags = ["vmseries"]
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
    named_ports = [
      {
        name = "http"
        port = 80
      },
      {
        name = "https"
        port = 443
      }
    ]
    network_interfaces = [
      {
        subnetwork       = "fw-untrust-sub"
        private_ip       = "10.210.12.130"
        create_public_ip = true
      },
      {
        subnetwork       = "fw-mgmt-sub"
        private_ip       = "10.210.12.2"
        create_public_ip = true
      },
      {
        subnetwork = "fw-trust-sub"
        private_ip = "10.210.0.2"
      }
    ]
  },
  fw-vmseries-02 = {
    name = "fw-vmseries-02"
    zone = "europe-west2-b"
    tags = ["vmseries"]
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
    named_ports = [
      {
        name = "http"
        port = 80
      },
      {
        name = "https"
        port = 443
      }
    ]
    network_interfaces = [
      {
        subnetwork       = "fw-untrust-sub"
        private_ip       = "10.210.12.131"
        create_public_ip = true
      },
      {
        subnetwork       = "fw-mgmt-sub"
        private_ip       = "10.210.12.3"
        create_public_ip = true
      },
      {
        subnetwork = "fw-trust-sub"
        private_ip = "10.210.0.3"
      }
    ]
  }
}

# Internal Network Loadbalancer
lbs_internal = {
  internal-lb = {
    name              = "internal-lb"
    health_check_port = "80"
    backends          = ["fw-vmseries-01", "fw-vmseries-02"]
    ip_address        = "10.210.0.10"
    subnetwork        = "fw-trust-sub"
    network           = "fw-trust-vpc"
  }
}

# External Network Loadbalancer
lbs_external = {
  external-lb = {
    name     = "external-lb"
    backends = ["fw-vmseries-01", "fw-vmseries-02"]
    rules = {
      all-ports = {
        ip_protocol = "L3_DEFAULT"
      }
    }
    http_health_check_port         = "80"
    http_health_check_request_path = "/php/login.php"
  }
}