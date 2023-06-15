variable "org_domain" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "pipeline_project_id" {
  description = "Pipeline project id for making terraform api calls"
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

variable "connectivity_network_self_link" {
  description = "Output from connectivity module for network peering"
}

variable "spoke_name" {
  description = "The name of the spoke being deployed (alpha numeric)"
  type        = string
}

variable "spoke_subdomain" {
  description = "DNS subdomain for the spoke being deployed"
  type        = string
}

variable "spoke_vpc_primary_prefix" {
  description = "10.x.0.0/16 subnet for networks and workloads"
  type        = string
}

variable "spoke_vpc_primary_newbits" {
  description = "The number of additional bits with which to extend the cidrsubnet prefix, see terraform cidrsubnet"
  type        = number
}

variable "spoke_vpc_primary_netnum" {
  description = "The number which will be used to populate the additional bits added to the prefix, see terraform cidrsubnet"
  type        = number
}
