resource "azuredevops_project" "project" {
  name       = var.project
  description        = var.project_description
}

terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}