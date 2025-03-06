locals {
  vnetLzId = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id
  snetvmId = var.deployingAllInOne == true ? var.snetvmId : data.azurerm_subnet.snet-vm.0.id

  kv_name = [for v in data.azurerm_resources.lz_rg_resource_s.resources : v.name if v.type == "Microsoft.KeyVault/vaults"].0
  akvId   = data.azurerm_key_vault.akv.id

  # Bastion resource names
  hub_bastion_name    = data.azurerm_resources.hub_bastion_s.resources.0.name
  hub_bastion_rg_name = data.azurerm_resources.hub_bastion_s.resources.0.resource_group_name
}
