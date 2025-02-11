#--------------------------------------------------------------
#   Terraform States Resource Group
#--------------------------------------------------------------
#   / Resource Group
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.location_short}-${var.base_name}-platform-lz"
  location = var.location
}

#--------------------------------------------------------------
#   Terraform States Storage Account
#--------------------------------------------------------------
#   / Main location storage account for remote backend Terraform States
resource "azurerm_storage_account" "this" {
  name                = substr("st${var.location_short}${var.base_name}platformlz", 0, 24)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  large_file_share_enabled        = false
  nfsv3_enabled                   = false
  local_user_enabled              = false
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false # Disable anonymous public read access to containers and blobs
  https_traffic_only_enabled      = true  # Require secure transfer (HTTPS) to the storage account for REST API Operations
  min_tls_version                 = "TLS1_2"
}

################################  Store data in Storage Account  ################################
#------------------------------
# - Containers
#------------------------------
# PR-112 Inventory: Blob storage has an inventory capability 
resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name               = each.value
  storage_account_id = azurerm_storage_account.this.id

  # Infrastructure Protection: Block Internet access and restrict network connectivity to the Storage account via the Storage firewall and access the data objects in the Storage account via Private Endpoint which secures all traffic between VNet and the storage account over a Private Link.
  container_access_type = "private"
}
