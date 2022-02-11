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


resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

data "azurerm_client_config" "current" {
}

resource "azurerm_databricks_workspace" "databricks" {
  name                        = "${var.resource_prefix}-workspace"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  managed_resource_group_name = "${var.resource_prefix}-workspace-rg"
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.id
  azure_client_id     = var.client_id
  azure_client_secret = var.client_secret
  azure_tenant_id     = var.tenant_id
}


resource "databricks_cluster" "databricks_cluster" {
  depends_on              = [azurerm_databricks_workspace.databricks]
  cluster_name            = var.databricks_cluster_name
  spark_version           = "8.2.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  driver_node_type_id     = "Standard_DS3_v2"
  autotermination_minutes = 15
  num_workers             = 1
  spark_env_vars          = {
    "PYSPARK_PYTHON" : "/databricks/python3/bin/python3"
  }
  spark_conf = {
    "spark.databricks.cluster.profile" : "serverless",
    "spark.databricks.repl.allowedLanguages": "sql,python,r"
  }
  custom_tags = {
    "ResourceClass" = "Serverless"
  }
}


