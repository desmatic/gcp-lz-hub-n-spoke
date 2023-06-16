resource "google_project_service" "connectivity-pa-service-cloudbilling" {
  project = var.pipeline_project_id
  service = "cloudbilling.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "random_string" "project-connectivity-pa-suffix" {
  length  = 5
  special = false
  upper   = false
}

module "project-connectivity-pa-vpc" {
  source = "terraform-google-modules/project-factory/google"

  name       = "connectivity-pa-vpc"
  project_id = "connectivity-pa-vpc-${random_string.project-connectivity-pa-suffix.result}"
  org_id     = var.org_id
  folder_id  = var.connectivity_infraops_folder_id

  auto_create_network            = false
  billing_account                = var.billing_account
  create_project_sa              = false
  enable_shared_vpc_host_project = true

  depends_on = [
    google_project_service.connectivity-pa-service-cloudbilling
  ]
}

module "allow-external-ips-for-vm-instances" {
  source = "terraform-google-modules/org-policy/google"

  policy_for  = "project"
  project_id  = module.project-connectivity-pa-vpc.project_id
  constraint  = "compute.vmExternalIpAccess"
  policy_type = "list"
  enforce     = false

  depends_on = [
    module.project-connectivity-pa-vpc
  ]
}

module "enable-serial-port-access-for-vm-instances" {
  source = "terraform-google-modules/org-policy/google"

  policy_for  = "project"
  project_id  = module.project-connectivity-pa-vpc.project_id
  constraint  = "compute.disableSerialPortAccess"
  policy_type = "boolean"
  enforce     = false

  depends_on = [
    module.project-connectivity-pa-vpc
  ]
}
