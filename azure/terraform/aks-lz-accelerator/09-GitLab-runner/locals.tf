locals {
  # Existing resources extraction:
  lz_vnet_name         = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if v.type == "Microsoft.Network/virtualNetworks"].0
  acr_name             = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if v.type == "Microsoft.ContainerRegistry/registries"].0
  kv_name              = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if v.type == "Microsoft.KeyVault/vaults"].0
  aks_name             = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if v.type == "Microsoft.ContainerService/managedClusters"].0
  storage_account_name = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if(v.type == "Microsoft.Storage/storageAccounts" && lookup(v.tags, "Plan", "AbsentKey") == "08-AzSQL-Data")].0

  vnetLzId = data.azurerm_virtual_network.vnet-lz.id
  snetvmId = data.azurerm_subnet.snet-vm.id
  acrId    = data.azurerm_container_registry.acr.id
  akvId    = data.azurerm_key_vault.akv.id
  aksId    = data.azurerm_kubernetes_cluster.aks.id

  # sql_server_uai_id   = data.azurerm_resources.uai_s.resources.0.id
  sql_server_uai_id = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.id if(v.type == "Microsoft.ManagedIdentity/userAssignedIdentities" && lookup(v.tags, "Plan", "AbsentKey") == "08-AzSQL-Data")].0

  hub_bastion_name    = data.azurerm_resources.hub_bastion_s.resources.0.name
  hub_bastion_rg_name = data.azurerm_resources.hub_bastion_s.resources.0.resource_group_name
}
