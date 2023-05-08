module "compute-disable-serialport" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root     = var.landingzone_organization_deployment ? "organization" : "folder"
  policy_root_id  = var.landingzone_organization_deployment ? var.org_id : split("/", var.landingzone_folder_id)[1]
  constraint      = "compute.disableSerialPortAccess"
  policy_type     = "boolean"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    # Rule 1
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
}

module "compute-skip-default-network" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root     = var.landingzone_organization_deployment ? "organization" : "folder"
  policy_root_id  = var.landingzone_organization_deployment ? var.org_id : split("/", var.landingzone_folder_id)[1]
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
  policy_type     = "boolean"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    # Rule 1
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
}
