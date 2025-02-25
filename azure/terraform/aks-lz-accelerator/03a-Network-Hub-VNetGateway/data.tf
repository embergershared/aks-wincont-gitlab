data "azurerm_virtual_network" "vnethub" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.vnetHubName
  resource_group_name = var.rgHubName
}

data "azurerm_subnet" "snet-gateway" {
  count                = var.deployingAllInOne == true ? 0 : 1
  name                 = "GatewaySubnet"
  virtual_network_name = var.vnetHubName
  resource_group_name  = var.rgHubName
}
