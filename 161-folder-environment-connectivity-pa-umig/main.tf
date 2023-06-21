module "paloalto" {
  source = "./modules/paloalto-v1.0/"

  billing_account                               = var.billing_account
  connectivity_network_self_link                = var.connectivity_network_self_link
  connectivity_primary_region_subnets_self_link = var.connectivity_primary_region_subnets_self_link
  connectivity_vpc_project_id                   = var.connectivity_vpc_project_id
  connectivity_infraops_folder_id               = var.connectivity_infraops_folder_id
  org_domain                                    = var.org_domain
  org_id                                        = var.org_id
  pipeline_project_id                           = var.pipeline_project_id
  region_primary                                = var.region_primary
  zone_primary                                  = var.zone_primary
  zone_secondary                                = var.zone_secondary
}
