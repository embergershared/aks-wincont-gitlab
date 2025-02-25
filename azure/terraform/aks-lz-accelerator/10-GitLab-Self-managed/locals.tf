locals {
  vnetLzId = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id
  snetvmId = var.deployingAllInOne == true ? var.snetvmId : data.azurerm_subnet.snet-vm.0.id
}
