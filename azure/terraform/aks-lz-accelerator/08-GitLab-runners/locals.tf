locals {
  vnetLzId = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id
  snetvmId = var.deployingAllInOne == true ? var.snetvmId : data.azurerm_subnet.snet-vm.0.id

  acrId = var.deployingAllInOne == true ? var.acrId : data.azurerm_container_registry.acr.0.id
  akvId = var.deployingAllInOne == true ? var.akvId : data.azurerm_key_vault.akv.0.id
  aksId = var.deployingAllInOne == true ? var.aksId : data.azurerm_kubernetes_cluster.aks.0.id
}
