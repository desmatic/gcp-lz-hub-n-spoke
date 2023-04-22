resource "google_organization_iam_binding" "iam-bind-network-admin" {
  org_id = var.org_id
  role   = "roles/compute.networkAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}

resource "google_organization_iam_binding" "iam-bind-security-admin" {
  org_id = var.org_id
  role   = "roles/compute.securityAdmin"

  members = [
    "group:${module.group-sre.id}",
  ]
}
