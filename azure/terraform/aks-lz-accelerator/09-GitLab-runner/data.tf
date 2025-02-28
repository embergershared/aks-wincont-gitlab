# Gather all resources from the Landing Zone Resource Group, to extract the ones needed through filters in locals.tf
data "azurerm_resources" "lz_rg_resource_s" {
  resource_group_name = var.rgLzName
}

# Data providers for required resources
data "azurerm_virtual_network" "vnet-lz" {
  name                = local.lz_vnet_name
  resource_group_name = var.rgLzName
}
data "azurerm_subnet" "snet-vm" {
  name                 = "snet-vm"
  virtual_network_name = data.azurerm_virtual_network.vnet-lz.name
  resource_group_name  = data.azurerm_virtual_network.vnet-lz.resource_group_name
}
data "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = var.rgLzName
}
data "azurerm_key_vault" "akv" {
  name                = local.kv_name
  resource_group_name = var.rgLzName
}
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = var.rgLzName
}
data "azurerm_storage_account" "poc_st_acct" {
  name                = local.storage_account_name
  resource_group_name = var.rgLzName
}
data "azurerm_storage_share" "poc_st_share" {
  name                 = var.storage_account_fileshare_name
  storage_account_name = data.azurerm_storage_account.poc_st_acct.name
}

# Gather required resources (Bastion) from the Hub Resource Group
data "azurerm_resources" "hub_bastion_s" {
  resource_group_name = var.rgHubName
  type                = "Microsoft.Network/bastionHosts"
}

# Generating the setup script from PowerShell file
data "template_file" "gl_runner_script" {
  template = file("Gitlab-runner-setup.ps1")
  vars = {
    GitLabRunnerToken = "${var.gitlab_runner_token}",
    StAcctName        = "${data.azurerm_storage_account.poc_st_acct.name}",
    StShareName       = "${data.azurerm_storage_share.poc_st_share.name}",
    StAcctAccessKey   = "${data.azurerm_storage_account.poc_st_acct.primary_access_key}",
  }
}
