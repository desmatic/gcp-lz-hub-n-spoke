resource "google_project_service" "identity-groups-service-cloudidentity" {
  project = var.pipeline_project_id
  service = "cloudidentity.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "identity-groups-service-cloudresourcemanager" {
  project = var.pipeline_project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_organization_iam_member" "azsec-gcp-infraops-read-viewer" {
  org_id = var.org_id
  role   = "roles/viewer"

  member = "group:azsec-gcp-infraops-read@${var.org_domain}"
}

resource "google_organization_iam_member" "azsec-gcp-csoc-read-viewer" {
  org_id = var.org_id
  role   = "roles/viewer"

  member = "group:azsec-gcp-csoc-read@${var.org_domain}"
}

resource "google_organization_iam_member" "azsec-gcp-devops-read-viewer" {
  org_id = var.org_id
  role   = "roles/viewer"

  member = "group:azsec-gcp-devops-read@${var.org_domain}"
}

resource "google_organization_iam_member" "azsec-gcp-dre-read-viewer" {
  org_id = var.org_id
  role   = "roles/viewer"

  member = "group:azsec-gcp-dre-read@${var.org_domain}"
}

resource "google_organization_iam_member" "azsec-gcp-finops-read-viewer" {
  org_id = var.org_id
  role   = "roles/viewer"

  member = "group:azsec-gcp-finops-read@${var.org_domain}"
}

resource "google_organization_iam_member" "azsec-gcp-sre-read-viewer" {
  org_id = var.org_id
  role   = "roles/viewer"

  member = "group:azsec-gcp-sre-read@${var.org_domain}"
}
