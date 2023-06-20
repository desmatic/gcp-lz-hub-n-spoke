variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "org_domain" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "pipeline_project_id" {
  description = "Pipeline project id for making terraform api calls"
  type        = string
}


variable "region_primary" {
  description = "Primary region for networks and workloads"
  type        = string
}

variable "zone_primary" {
  description = "Primary zone for networks and workloads"
}

variable "zone_secondary" {
  description = "Secondary zone for networks and workloads"
}

variable "spoke_domain" {
  description = "The fully qualified domain name for the environment"
  type        = string
}

variable "spoke_subdomain" {
  description = "The subdomain for the environment"
  type        = string
}

variable "spoke_name" {
  description = "The name of the environment resources are deployed to"
  type        = string
}

variable "spoke_folder_id" {
  description = "The name of the folder id where resource are deployed to"
  type        = string
}

variable "spoke_vpc_project_id" {
  description = "Project ID of host VPC for service projects"
  type        = string
}

variable "spoke_monitoring_project_id" {
  description = "Project ID to sending metrics to"
  type        = string
}

variable "spoke_secrets_project_id" {
  description = "Project ID where secrets are stored"
  type        = string
}

variable "spoke_subnetwork_primary" {
  description = "The name of the primary network in the host VPC"
  type        = string
}

variable "team_folder_name" {
  description = "The folder name for the team"
  type        = string
}
