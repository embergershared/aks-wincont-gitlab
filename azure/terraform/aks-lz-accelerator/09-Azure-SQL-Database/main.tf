locals {
  vnetLzId = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id

  speSubnetId  = var.deployingAllInOne == true ? var.speSubnetId : data.azurerm_subnet.snet-spe.0.id
  dnszonesqlId = var.deployingAllInOne == true ? var.dnszonesqlId : data.azurerm_private_dns_zone.dnszone-sql.0.id

  domain_name = {
    sql = "privatelink.database.windows.net"
  }

  databases = {
    my_sample_db = {
      name         = "app_db"
      create_mode  = "Default"
      collation    = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
      max_size_gb  = 50
      sku_name     = "S0"

      short_term_retention_policy = {
        retention_days           = 1
        backup_interval_in_hours = 24
      }

      long_term_retention_policy = {
        weekly_retention  = "P2W1D"
        monthly_retention = "P2M"
        yearly_retention  = "P1Y"
        week_of_year      = 1
      }
    }
    TimeTracker = {
      name         = "TimeTracker"
      create_mode  = "Default"
      collation    = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
      max_size_gb  = 50
      sku_name     = "S0"

      short_term_retention_policy = {
        retention_days           = 1
        backup_interval_in_hours = 24
      }

      long_term_retention_policy = {
        weekly_retention  = "P2W1D"
        monthly_retention = "P2M"
        yearly_retention  = "P1Y"
        week_of_year      = 1
      }
    }
    Classifieds = {
      name         = "Classifieds"
      create_mode  = "Default"
      collation    = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
      max_size_gb  = 50
      sku_name     = "S0"

      short_term_retention_policy = {
        retention_days           = 1
        backup_interval_in_hours = 24
      }

      long_term_retention_policy = {
        weekly_retention  = "P2W1D"
        monthly_retention = "P2M"
        yearly_retention  = "P1Y"
        week_of_year      = 1
      }
    }
    Jobs = {
      name         = "Jobs"
      create_mode  = "Default"
      collation    = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
      max_size_gb  = 50
      sku_name     = "S0"

      short_term_retention_policy = {
        retention_days           = 1
        backup_interval_in_hours = 24
      }

      long_term_retention_policy = {
        weekly_retention  = "P2W1D"
        monthly_retention = "P2M"
        yearly_retention  = "P1Y"
        week_of_year      = 1
      }
    }
  }
}

data "azurerm_virtual_network" "vnet-lz" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.vnetLzName
  resource_group_name = var.rgLzName
}

data "azurerm_subnet" "snet-spe" {
  count                = var.deployingAllInOne == true ? 0 : 1
  name                 = "snet-spe"
  virtual_network_name = var.vnetLzName
  resource_group_name  = var.rgLzName
}

data "azurerm_private_dns_zone" "dnszone-sql" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = local.domain_name.sql
  resource_group_name = var.rgLzName
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["lz"]
}

module "avm-res-managedidentity-userassignedidentity" {
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.3"
  name                = module.naming.user_assigned_identity.name_unique
  location            = var.location # data.azurerm_resource_group.rg.location
  resource_group_name = var.rgLzName # data.azurerm_resource_group.rg.name
}

module "sql_server" {
  source                        = "Azure/avm-res-sql-server/azurerm"
  enable_telemetry              = false
  name                          = module.naming.sql_server.name_unique
  resource_group_name           = var.rgLzName
  administrator_login           = var.sql_admin_username
  administrator_login_password  = var.sql_admin_password
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

  tags = {
    "SecurityControl" = "Ignore"
  }
}
