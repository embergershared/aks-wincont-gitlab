# Gather all resources from the Landing Zone Resource Group, to extract the ones needed through filters in locals.tf
data "azurerm_resources" "lz_rg_resource_s" {
  resource_group_name = var.rgLzName
}
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name #split("/", local.aksId)[8]
  resource_group_name = var.rgLzName   #split("/", local.aksId)[4]
}
data "azurerm_key_vault" "akv" {
  name                = local.kv_name
  resource_group_name = var.rgLzName
}
data "azurerm_key_vault_secret" "cs_secret" {
  name         = var.cs_kv_secret_name
  key_vault_id = data.azurerm_key_vault.akv.id
}
# This is the secret name in the Key Vault
#*/
