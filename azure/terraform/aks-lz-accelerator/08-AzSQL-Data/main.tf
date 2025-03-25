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

  tags = merge(var.base_tags, var.plan_tags)
}

resource "azurerm_key_vault_secret" "az_sql_pwd_secret" {
  name         = "AzSql-Server-Password"
  value        = random_password.sql_password.result
  key_vault_id = local.akvId

  tags = merge(var.base_tags, var.plan_tags)
}


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

# Connection strings
resource "azurerm_key_vault_secret" "az_sql_conn_string" {
  for_each = local.databases

  name         = replace("AzSql-Db-ConnectionString-${each.value.name}", "_", "-")
  value        = "Server=tcp:${module.naming.sql_server.name_unique}.database.windows.net,1433;Initial Catalog=${each.value.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${random_password.sql_password.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  key_vault_id = local.akvId

  tags = merge(var.base_tags, var.plan_tags)
}


#--------------------------------------------------------------
#   PoC Data Storage Account
#--------------------------------------------------------------
#   / Storage account for data related to the PoC
resource "azurerm_storage_account" "this" {
  name                = "st391575s3hwwpoc"
  resource_group_name = var.rgLzName
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  large_file_share_enabled        = false
  nfsv3_enabled                   = false
  local_user_enabled              = false
  public_network_access_enabled   = false
  shared_access_key_enabled       = false # Enable to allow File share mounting on the GitLab Runner
  allow_nested_items_to_be_public = false # Disable anonymous public read access to containers and blobs
  https_traffic_only_enabled      = true  # Require secure transfer (HTTPS) to the storage account for REST API Operations
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.authorized_ips
    virtual_network_subnet_ids = []
    private_link_access {
      endpoint_resource_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Security/datascanners/StorageDataScanner"
      endpoint_tenant_id   = var.tenant_id
    }
  }

  tags = merge(var.base_tags, var.plan_tags)
}

################################  Store data in Storage Account  ################################
#------------------------------
# - Containers
#------------------------------
resource "azurerm_storage_container" "this" {
  name               = "poc-data"
  storage_account_id = azurerm_storage_account.this.id

  # Infrastructure Protection: Block Internet access and restrict network connectivity to the Storage account via the Storage firewall and access the data objects in the Storage account via Private Endpoint which secures all traffic between VNet and the storage account over a Private Link.
  container_access_type = "private"
}
/*
#------------------------------
# - File share
#------------------------------
resource "azurerm_storage_share" "this" {
  name               = "poc-data"
  quota              = 1024
  storage_account_id = azurerm_storage_account.this.id
}
#*/

################################  Private endpoints for Storage Account  ################################

resource "azurerm_private_endpoint" "pe_blob" {
  name                          = "pe-to-blob-${replace(azurerm_storage_account.this.name, "-", "")}"
  resource_group_name           = var.rgLzName
  location                      = var.location
  subnet_id                     = local.speSubnetId
  custom_network_interface_name = "nic-pe-to-blob-${replace(azurerm_storage_account.this.name, "-", "")}"

  private_service_connection {
    name                           = "${var.vnetLzName}_${data.azurerm_subnet.snet-spe.0.name}_connection"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = true
    request_message                = "Please approve this PE connection to ${var.vnetLzName}/${data.azurerm_subnet.snet-spe.0.name}."
  }

  tags = merge(var.base_tags, var.plan_tags)
}
#     / Create Private DNS records for Private Endpoint
resource "azurerm_private_dns_a_record" "pe_blob_dns_record" {
  name                = azurerm_storage_account.this.name
  zone_name           = "privatelink.blob.core.windows.net"
  resource_group_name = var.rgLzName
  ttl                 = 30
  records             = [azurerm_private_endpoint.pe_blob.private_service_connection[0].private_ip_address]

  lifecycle { ignore_changes = [tags["creator"]] }
  tags = merge(var.base_tags, var.plan_tags)
}
#*/

/*
resource "azurerm_private_endpoint" "pe_file" {
  name                          = "pe-to-file-${replace(azurerm_storage_account.this.name, "-", "")}"
  resource_group_name           = var.rgLzName
  location                      = var.location
  subnet_id                     = local.speSubnetId
  custom_network_interface_name = "nic-pe-to-file-${replace(azurerm_storage_account.this.name, "-", "")}"

  private_service_connection {
    name                           = "${var.vnetLzName}_${data.azurerm_subnet.snet-spe.0.name}_connection"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = true
    request_message                = "Please approve this PE connection to ${var.vnetLzName}/${data.azurerm_subnet.snet-spe.0.name}."
  }

  tags = merge(var.base_tags, var.plan_tags)
}
#     / Create Private DNS records for Private Endpoint
resource "azurerm_private_dns_a_record" "pe_file_dns_record" {
  name                = azurerm_storage_account.this.name
  zone_name           = "privatelink.file.core.windows.net"
  resource_group_name = var.rgLzName
  ttl                 = 30
  records             = [azurerm_private_endpoint.pe_file.private_service_connection[0].private_ip_address]

  lifecycle { ignore_changes = [tags["creator"]] }
  tags = merge(var.base_tags, var.plan_tags)
}
#*/
