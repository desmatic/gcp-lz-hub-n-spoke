output "sentinel_account_email" {
  value = "${google_service_account.sentinel-service-account.account_id}@${var.logging_project_id}.iam.gserviceaccount.com"
}

output "sentinel_identity_federation_pool_id" {
  value = local.workload_identity_pool_id
}

output "sentinel_identity_federation_provider_id" {
  value = google_iam_workload_identity_pool_provider.sentinel-workload-identity-pool-provider.workload_identity_pool_provider_id
}
