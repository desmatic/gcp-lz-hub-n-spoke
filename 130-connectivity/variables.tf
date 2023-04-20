variable "org_domain" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "environment_folder_id" {
  description = "The organization folder id for different environments"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "region_primary" {
  description = "Primary region for networks and workloads"
}

variable "region_secondary" {
  description = "Secondary region for networks and workloads"
}

variable "landingzone_network" {
  description = "10.x.0.0/16 subnet for networks and workloads"
}
