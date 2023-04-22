module "compute-disable-serialport" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.2.2"

  organization_id  = var.org_id
  constraint       = "compute.disableSerialPortAccess"
  policy_type      = "boolean"
  enforce          = true
}

module "compute-disable-default-network" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.2.2"

  organization_id  = var.org_id
  constraint       = "constraints/compute.skipDefaultNetworkCreation"
  policy_type      = "boolean"
  enforce          = true
}
