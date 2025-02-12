terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71"
    }
  }

  backend "azurerm" {
    subscription_id      = "4c88693f-5cc9-4f30-9d1e-d58d4221cf25"
    resource_group_name  = "rg-use2-391575-s3-akswincont-lz-01"
    storage_account_name = "st391575s3tfstates"
    container_name       = "akswincont-lz"
    key                  = "03-network-hub"
    use_azuread_auth     = true
  }
}

# provider "azurerm" {
#   features {}
# }
