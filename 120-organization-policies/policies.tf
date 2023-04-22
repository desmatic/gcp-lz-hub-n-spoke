module "compute-disable-serialport" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.2.2"

  organization_id = var.org_id
  policy_for      = "organization"
  constraint      = "compute.disableSerialPortAccess"
  policy_type     = "boolean"
  enforce         = true
}

module "compute-skip-default-network" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.2.2"

  organization_id = var.org_id
  policy_for      = "organization"
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
  policy_type     = "boolean"
  enforce         = true
}
