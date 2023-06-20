module "teamskeleton" {
  source = "./modules/team-skeleton-v1.0/"

  billing_account             = var.billing_account
  org_domain                  = var.org_domain
  org_id                      = var.org_id
  pipeline_project_id         = var.pipeline_project_id
  region_primary              = var.region_primary
  zone_primary                = var.zone_primary
  zone_secondary              = var.zone_secondary
  spoke_domain                = module.spoke.spoke_domain
  spoke_subdomain             = module.spoke.spoke_subdomain
  spoke_name                  = module.spoke.spoke_name
  spoke_vpc_project_id        = module.spoke.spoke_vpc_project_id
  spoke_monitoring_project_id = module.spoke.spoke_monitoring_project_id
  spoke_secrets_project_id    = module.spoke.spoke_secrets_project_id
  spoke_subnetwork_primary    = module.spoke.spoke_subnetwork_primary
  #  spoke_vpc_primary_netnum  = 8
  #  spoke_vpc_primary_newbits = 6
  #  spoke_vpc_primary_prefix  = var.landingzone_network
  team_folder_name = "TeamSkeleton"
  spoke_folder_id  = module.spoke.spoke_folder_id
}
