module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"

  suffix = ["lz"]
}

resource "random_password" "sql_password" {
  length  = 16
  special = true
  numeric = true
  lower   = true
  upper   = true
}

module "avm-res-managedidentity-userassignedidentity" {
  source           = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version          = "0.3.3"
  enable_telemetry = false

  name                = "uai-${module.naming.sql_server.name_unique}"
  location            = var.location # data.azurerm_resource_group.rg.location
  resource_group_name = var.rgLzName # data.azurerm_resource_group.rg.name
}

resource "azurerm_key_vault_secret" "sql_pwd_secret" {
  name         = "AzSQLServerPassword"
  value        = random_password.sql_password.result
  key_vault_id = local.akvId
}

/*
module "sql_server" {
  source           = "Azure/avm-res-sql-server/azurerm"
  enable_telemetry = false

  name                          = module.naming.sql_server.name_unique
  resource_group_name           = var.rgLzName
  administrator_login           = var.sql_admin_username
  administrator_login_password  = random_password.sql_password.result
  public_network_access_enabled = false
  location                      = var.location
  server_version                = "12.0"
  databases                     = local.databases

  azuread_administrator = {
    azuread_authentication_only = false
    login_username              = module.avm-res-managedidentity-userassignedidentity.client_id
    object_id                   = module.avm-res-managedidentity-userassignedidentity.principal_id
  }

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [local.dnszonesqlId]
      subnet_resource_id            = local.speSubnetId
    }
  }

  tags = merge(
    var.base_tags,
    var.plan_tags,
    {
      "SecurityControl" = "Ignore"
    }
  )
}
#*/
