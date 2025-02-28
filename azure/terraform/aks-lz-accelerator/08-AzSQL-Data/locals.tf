locals {
  vnetLzId = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id

  speSubnetId  = var.deployingAllInOne == true ? var.speSubnetId : data.azurerm_subnet.snet-spe.0.id
  dnszonesqlId = var.deployingAllInOne == true ? var.dnszonesqlId : data.azurerm_private_dns_zone.dnszone-sql.0.id
  akvId        = var.deployingAllInOne == true ? var.akvId : data.azurerm_key_vault.akv.0.id

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
