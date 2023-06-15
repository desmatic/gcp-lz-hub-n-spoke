module "spoke" {
  source = "./modules/spoke-v1.0/"

  spoke_name                = "FixOnFail"
  spoke_subdomain           = "fof"
  spoke_vpc_primary_prefix  = var.landingzone_network
  spoke_vpc_primary_newbits = 6
  spoke_vpc_primary_netnum  = 24

  billing_account                = var.billing_account
  connectivity_network_self_link = var.connectivity_network_self_link
  environment_folder_id          = var.environment_folder_id
  org_domain                     = var.org_domain
  org_id                         = var.org_id
  pipeline_project_id            = var.pipeline_project_id
  region_primary                 = var.region_primary
}
