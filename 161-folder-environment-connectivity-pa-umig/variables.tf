variable "org_domain" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "pipeline_project_id" {
  description = "Pipeline project id for making terraform api calls"
  type        = string
}

variable "environment_folder_id" {
  description = "The folder id for deploying resources under"
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
  type        = string
}

variable "zone_primary" {
  description = "Primary zone for networks and workloads"
}

variable "zone_secondary" {
  description = "Secondary zone for networks and workloads"
}

variable "landingzone_network" {
  description = "10.x.0.0/16 subnet for networks and workloads"
  type        = string
}


variable "connectivity_vpc_project_id" {
  description = "The host vpc project id"
  type        = string
}

variable "connectivity_primary_region_subnets_self_link" {
  description = "The primary region subnet"
  type        = string
}

variable "connectivity_infraops_folder_id" {
  description = "The folder id for the active directory project"
}

variable "connectivity_network_self_link" {
  description = "Output from connectivity module for network peering"
  type        = string
}

