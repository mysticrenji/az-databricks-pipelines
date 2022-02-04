terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }

    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }

    databricks = {
      source = "databrickslabs/databricks"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {}

provider "azuredevops" {
}
