locals {
  vnetHubId       = var.deployingAllInOne == true ? var.vnetHubId : data.azurerm_virtual_network.vnethub.0.id
  bastionSubnetId = var.deployingAllInOne == true ? var.speSubnetId : data.azurerm_subnet.snet-bastion.0.id
}
