# Gather all resources from the Landing Zone Resource Group, to extract the ones needed through filters in locals.tf
data "azurerm_resources" "lz_rg_resource_s" {
  resource_group_name = var.rgLzName
}

data "azurerm_virtual_network" "vnet-lz" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.vnetLzName
  resource_group_name = var.rgLzName
}

data "azurerm_subnet" "snet-vm" {
  count                = var.deployingAllInOne == true ? 0 : 1
  name                 = "snet-vm"
  virtual_network_name = var.vnetLzName
  resource_group_name  = var.rgLzName
}
data "azurerm_key_vault" "akv" {
  name                = local.kv_name
  resource_group_name = var.rgLzName
}
