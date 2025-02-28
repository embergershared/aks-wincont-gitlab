locals {
  vnetHubId       = var.deployingAllInOne == true ? var.vnetHubId : data.azurerm_virtual_network.vnethub.0.id
  gatewaySubnetId = var.deployingAllInOne == true ? var.speSubnetId : data.azurerm_subnet.snet-gateway.0.id
}
