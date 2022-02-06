terraform {
  backend "azurerm" {
    resource_group_name  = "sandbox-storage"
    storage_account_name = "mystickenshin"
    container_name       = "dataops"
    key                  = "terraform.tfstate"

  }
}