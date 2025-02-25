
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
