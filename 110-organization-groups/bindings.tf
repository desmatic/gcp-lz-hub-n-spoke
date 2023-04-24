resource "google_organization_iam_binding" "iam-bind-billing-account-user" {
  org_id = var.org_id
  role   = "roles/billing.user"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-compute-network-admin" {
  org_id = var.org_id
  role   = "roles/compute.networkAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-compute-security-admin" {
  org_id = var.org_id
  role   = "roles/compute.securityAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-compute-shared-vpc-admin" {
  org_id = var.org_id
  role   = "roles/compute.xpnAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-folder-admin" {
  org_id = var.org_id
  role   = "roles/resourcemanager.folderAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-monitoring-admin" {
  org_id = var.org_id
  role   = "roles/monitoring.admin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-organization-administrator" {
  org_id = var.org_id
  role   = "roles/resourcemanager.organizationAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-organization-policy-administrator" {
  org_id = var.org_id
  role   = "roles/orgpolicy.policyAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-project-creator" {
  org_id = var.org_id
  role   = "roles/resourcemanager.projectCreator"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-project-deleter" {
  org_id = var.org_id
  role   = "roles/resourcemanager.projectDeleter"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-service-account-admin" {
  org_id = var.org_id
  role   = "roles/iam.serviceAccountAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-storage-admin" {
  org_id = var.org_id
  role   = "roles/storage.admin"

  members = [
    "group:${module.group-sre.id}",
  ]
}
