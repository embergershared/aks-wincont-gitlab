# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["hub"]
}

module "publicIpBastion" {
  source           = "Azure/avm-res-network-publicipaddress/azurerm"
  version          = "0.2.0"
  enable_telemetry = false

  resource_group_name = var.rgHubName
  name                = "pip-azbastion"
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availabilityZones

  tags = merge(var.base_tags, var.plan_tags)
}

module "azure_bastion" {
  source           = "Azure/avm-res-network-bastionhost/azurerm"
  enable_telemetry = false

  name                = module.naming.bastion_host.name_unique
  resource_group_name = var.rgHubName
  location            = var.location
  copy_paste_enabled  = true
  file_copy_enabled   = false
  sku                 = "Standard"
  ip_configuration = {
    name                 = "bastion-ipconfig"
    subnet_id            = local.bastionSubnetId
    public_ip_address_id = module.publicIpBastion.resource_id
  }
  ip_connect_enabled     = true
  scale_units            = 4
  shareable_link_enabled = true
  tunneling_enabled      = true
  kerberos_enabled       = false

  tags = merge(var.base_tags, var.plan_tags)
}
