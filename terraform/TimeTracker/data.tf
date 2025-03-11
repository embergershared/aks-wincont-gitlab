# Gather all resources from the Landing Zone Resource Group, to extract the ones needed through filters in locals.tf
data "azurerm_resources" "lz_rg_resource_s" {
  resource_group_name = var.rgLzName
}

data "azurerm_kubernetes_cluster" "this" {
  name                = split("/", local.aksId)[8]
  resource_group_name = split("/", local.aksId)[4]
}

#*/
