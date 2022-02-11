module "azure-devops" {
  source              = "./modules/az-devops"
  project             = var.project
  project_description = var.project_description
}

module "azure-databricks" {
  source                   = "./modules/az-databricks"
  resource_prefix          = var.resource_prefix
  email_notifier           = var.email_notifier
  rg_name                  = var.rg_name
  location                 = var.location
  email_id                 = var.email_id
  project                  = var.project
  organizationname         = var.organizationname
  client_id                = var.client_id
  client_secret            = var.client_secret
  tenant_id                = var.tenant_id
  databricks_cluster_name  = var.databricks_cluster_name
}
