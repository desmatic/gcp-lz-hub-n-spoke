variable "logging_project_id" {
  description = "Logging project id to grant sentinel access"
  type        = string
}

variable "logging_project_number" {
  description = "Logging project id to grant sentinel access"
  type        = string
}

variable "sentinel_tenant_id" {
  type        = string
  nullable    = false
  description = "Please enter your Sentinel tenant id"
}

