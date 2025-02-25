locals {
  vnetHubId         = var.deployingAllInOne == true ? var.vnetHubId : data.azurerm_virtual_network.vnethub.0.id
  firewallPrivateIp = var.deployingAllInOne == true ? var.firewallPrivateIp : data.azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address
}
