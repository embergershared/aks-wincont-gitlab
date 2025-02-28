locals {
  # Existing resources extraction:
  lz_vnet_name = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if v.type == "Microsoft.Network/virtualNetworks"]



  vnetLzId = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id
  snetvmId = var.deployingAllInOne == true ? var.snetvmId : data.azurerm_subnet.snet-vm.0.id

  acrId = var.deployingAllInOne == true ? var.acrId : data.azurerm_container_registry.acr.0.id
  akvId = var.deployingAllInOne == true ? var.akvId : data.azurerm_key_vault.akv.0.id
  aksId = var.deployingAllInOne == true ? var.aksId : data.azurerm_kubernetes_cluster.aks.0.id

  sql_server_uai_id   = data.azurerm_resources.uai_s.resources.0.id
  hub_bastion_name    = data.azurerm_resources.hub_bastion_s.resources.0.name
  hub_bastion_rg_name = data.azurerm_resources.hub_bastion_s.resources.0.resource_group_name
}
