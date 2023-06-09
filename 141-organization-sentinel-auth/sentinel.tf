locals {
  sentinel_app_id           = "2041288c-b303-4ca0-9076-9612db3beeb2"   // Do not change it. It's our Azure Active Directory app id that will be used for authentication with your project.
  sentinel_auth_id          = "33e01921-4d64-4f8c-a055-5bdaffd5e33d"   // Do not change it. It's our tenant id that will be used for authentication with your project.
  workload_identity_pool_id = replace(var.sentinel_tenant_id, "-", "") // Do not change it.
}

resource "google_iam_workload_identity_pool" "sentinel-workload-identity-pool" {
  provider                  = google-beta
  project                   = var.logging_project_id
  workload_identity_pool_id = local.workload_identity_pool_id
  display_name              = "sentinel-workload-identity-pool"
}

resource "google_iam_workload_identity_pool_provider" "sentinel-workload-identity-pool-provider" {
  provider                           = google-beta
  workload_identity_pool_id          = local.workload_identity_pool_id
  workload_identity_pool_provider_id = "sentinel-identity-provider"
  project                            = var.logging_project_id
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }

  oidc {
    allowed_audiences = ["api://${local.sentinel_app_id}"]
    issuer_uri        = "https://sts.windows.net/${local.sentinel_auth_id}"
  }
}

resource "google_service_account" "sentinel-service-account" {
  account_id   = "sentinel-service-account"
  display_name = "Sentinel Service Account"
  project      = var.logging_project_id
}

resource "google_project_iam_custom_role" "sentinel-custom-role" {
  role_id     = "SentinelCustomRole"
  title       = "Sentinel Custom Role"
  description = "Role that allowes pulling messages from pub/sub"
  permissions = ["pubsub.subscriptions.consume", "pubsub.subscriptions.get"]
  project     = var.logging_project_id
}

resource "google_project_iam_member" "bind-sentinel-custom-role-to-sentinel-service-account" {
  provider = google-beta
  project  = var.logging_project_id
  role     = google_project_iam_custom_role.sentinel-custom-role.name

  member = "serviceAccount:${google_service_account.sentinel-service-account.account_id}@${var.logging_project_id}.iam.gserviceaccount.com"
}

resource "google_service_account_iam_binding" "bind-workloadIdentityUser-role-to-sentinel-service-account" {
  provider           = google-beta
  service_account_id = google_service_account.sentinel-service-account.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/projects/${var.logging_project_number}/locations/global/workloadIdentityPools/${local.workload_identity_pool_id}/*",
  ]
}
