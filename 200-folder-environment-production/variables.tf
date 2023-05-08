variable "org_domain" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "environment_folder_id" {
  description = "The organization folder id for different environments"
  type        = string
}

variable "pipeline_project_id" {
  description = "Pipeline project id for making terraform api calls"
  type        = string
}
