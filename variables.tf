variable "project" {
  default = "Azure_Databricks"
}

variable "organizationname" {
  default = "renjiravindranathan"
}

variable "project_description" {
  default = "Databricks project"
}

variable "rg_name" {
  default = "dataops-management"
}
variable "location" {
  default = "West US"
}

variable "databricks_workspace_url" {
  description = "The URL to the Azure Databricks workspace (must start with https://)"
  type        = string
  default     = "https://dataops-managment-dev"
}

variable "resource_prefix" {
  description = "The prefix to use when naming the notebook and job"
  type        = string
  default     = "dataops-dev"
}

variable "email_notifier" {
  description = "The email address to send job status to"
  type        = list(string)
  default     = ["renji.ravindranathan@gmail.com"]
}


variable "email_id" {
  default = "renji.ravindranathan@gmail.com"
}

variable "backend_rg_group" {
  default = "sandbox-storage"
}

variable "backend_storage_name" {
  default = "mystickenshin"
}

variable "backend_container_name" {
  default = "dataops"
}

variable "backend_file" {
  default = "terraform.tfstate"

}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "databricks_cluster_name" {
  default ="databricks-development"
}