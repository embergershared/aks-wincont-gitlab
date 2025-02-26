data "azurerm_virtual_network" "vnet-lz" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.vnetLzName
  resource_group_name = var.rgLzName
}

data "azurerm_subnet" "snet-vm" {
  count                = var.deployingAllInOne == true ? 0 : 1
  name                 = "snet-vm"
  virtual_network_name = var.vnetLzName
  resource_group_name  = var.rgLzName
}

data "azurerm_container_registry" "acr" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.acrName
  resource_group_name = var.rgLzName
}

data "azurerm_key_vault" "akv" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.akvName
  resource_group_name = var.rgLzName
}

data "azurerm_kubernetes_cluster" "aks" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.aksName
  resource_group_name = var.rgLzName
}
