
# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["hub"]
}

module "publicIpVGW" {
  source              = "Azure/avm-res-network-publicipaddress/azurerm"
  version             = "0.2.0"
  resource_group_name = var.rgHubName
  name                = "pip-azvgw"
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availabilityZones

  tags = merge(var.base_tags, var.plan_tags)
}

# module "vgw" {
#   source  = "Azure/avm-ptn-vnetgateway/azurerm"
#   version = "0.6.3" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

#   location              = var.location
#   name                  = module.naming.virtual_network_gateway.name_unique
#   virtual_network_id    = local.vnetHubId
#   subnet_creation_enabled = false
#   ip_configurations = {
#     id = module.publicIpVGW.resource_id
#   }

#   local_network_gateways = [
#     {
#         name = module.naming.local_network_gateway.name_unique
#         address_space = var.localNetworkGatewayAddressSpace
#         gateway_fqdn = var.localNetworkGatewayFqdn
#         connection = {
#             name = module.naming.virtual_network_gateway_connection.name_unique
#             type = "IPsec"
#             shared_key = var.sharedKey
#         }
#     }
#   ]
# }

resource "azurerm_virtual_network_gateway" "vgw" {
  name                = module.naming.virtual_network_gateway.name_unique
  location            = var.location
  resource_group_name = var.rgHubName
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.sku
  active_active       = false
  enable_bgp          = false
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = module.publicIpVGW.resource_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = local.gatewaySubnetId
  }

  tags = merge(var.base_tags, var.plan_tags)
}

resource "azurerm_local_network_gateway" "lgw" {
  name                = module.naming.local_network_gateway.name_unique
  resource_group_name = var.rgHubName
  location            = var.location
  gateway_fqdn        = var.localNetworkGatewayFqdn
  address_space       = [var.localNetworkGatewayAddressSpace]

  tags = merge(var.base_tags, var.plan_tags)
}

resource "azurerm_virtual_network_gateway_connection" "vgw_connection" {
  name                       = module.naming.virtual_network_gateway_connection.name_unique
  resource_group_name        = var.rgHubName
  location                   = var.location
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.lgw.id
  shared_key                 = var.sharedKey

  tags = merge(var.base_tags, var.plan_tags)
}
