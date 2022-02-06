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
  tags                        = local.tags
}

provider "databricks" {
  host                = azurerm_databricks_workspace.databricks.workspace_url
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

# resource "databricks_repo" "nutter_in_home" {
#   url = "https://${var.organizationname}@dev.azure.com/${var.organizationname}/${var.project}/git/${var.project}"
# }
# resource "databricks_notebook" "this" {
#   path     = "${data.databricks_current_user.me.home}/Terraform"
#   language = "PYTHON"
#   content_base64 = base64encode(<<-EOT
#     # created from ${abspath(path.module)}
#     # admins group id: ${data.databricks_group.admins.id}
#     display(spark.range(10))
#     EOT
#   )
#   depends_on = [azurerm_databricks_workspace.this]

# }

# data "databricks_current_user" "me" {
#   depends_on = [azurerm_databricks_workspace.this]
# }

# data "databricks_group" "admins" {
#   display_name = "admins"
#   depends_on   = [azurerm_databricks_workspace.this]
# }



# resource "databricks_group_member" "my_member_a" {
#   group_id  = data.databricks_group.admins.id
#   member_id = databricks_user.me.id
# }

# data "databricks_node_type" "smallest" {
#   local_disk = true
# }

# // Get the latest Spark version to use for the cluster.
# data "databricks_spark_version" "latest" {}

# // Create the job, emailing notifiers about job success or failure.
# resource "databricks_job" "this" {
#   name = "${var.resource_prefix}-job-${data.databricks_current_user.me.alphanumeric}"
#   new_cluster {
#     num_workers   = 1
#     spark_version = data.databricks_spark_version.latest.id
#     node_type_id  = data.databricks_node_type.smallest.id
#   }
#   notebook_task {
#     notebook_path = databricks_notebook.this.path
#   }
#   email_notifications {
#     on_success = var.email_notifier
#     on_failure = var.email_notifier
#   }
#   depends_on = [azurerm_databricks_workspace.this]

# }

