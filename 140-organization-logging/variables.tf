variable "landingzone_organization_deployment" {
  description = "Deploy landing zone under organization or folder"
  type        = bool
}

variable "org_domain" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "landingzone_folder_id" {
  description = "The organization folder id for deploying the landingzone to"
  type        = string
}

variable "pipeline_project_id" {
  description = "Pipeline project id for making terraform api calls"
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