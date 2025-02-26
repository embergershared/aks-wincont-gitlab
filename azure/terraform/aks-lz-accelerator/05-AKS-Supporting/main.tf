module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["lz"]
}

module "avm-res-containerregistry-registry" {
  source                        = "Azure/avm-res-containerregistry-registry/azurerm"
  version                       = "0.3.1"
  name                          = var.acrName
  location                      = var.location
  resource_group_name           = var.rgLzName
  public_network_access_enabled = false
  network_rule_bypass_option    = "AzureServices"

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [local.dnszoneAcrId]
      subnet_resource_id            = local.speSubnetId
    }
  }

  tags = merge(var.base_tags, var.plan_tags)
}

module "avm-res-keyvault-vault" {
  source                        = "Azure/avm-res-keyvault-vault/azurerm"
  version                       = "0.9.1"
  name                          = var.akvName
  location                      = var.location
  resource_group_name           = var.rgLzName
  tenant_id                     = data.azurerm_client_config.tenant.tenant_id
  public_network_access_enabled = true
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [local.dnszoneAkvId]
      subnet_resource_id            = local.speSubnetId
    }
  }
  network_acls = {
    ip_rules = var.authorized_ips
  }

  tags = merge(var.base_tags, var.plan_tags)
}

resource "azurerm_role_assignment" "terraform_secretofficer_role_assignment" {
  scope                = module.avm-res-keyvault-vault.resource_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.tenant.object_id
}
