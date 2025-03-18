# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["lz"]
}
resource "random_password" "vm_password" {
  length  = 15
  special = true
  numeric = true
  lower   = true
  upper   = true
}
resource "azurerm_key_vault_secret" "this" {
  name         = "${module.naming.virtual_machine.name_unique}-password"
  value        = random_password.vm_password.result # var.jumpbox_admin_password
  key_vault_id = local.akvId
}
module "uai_msi_vm" {
  source           = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version          = "0.3.3"
  enable_telemetry = false

  name                = "uai-${module.naming.virtual_machine.name_unique}"
  location            = var.location # data.azurerm_resource_group.rg.location
  resource_group_name = var.rgLzName # data.azurerm_resource_group.rg.name

  tags = merge(var.base_tags, var.plan_tags)
}
module "jumpbox_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  #version = "0.17.0
  enable_telemetry = false

  name                = module.naming.virtual_machine.name_unique
  location            = var.location
  resource_group_name = var.rgLzName

  admin_username                     = var.jumpbox_admin_username
  admin_password                     = random_password.vm_password.result
  disable_password_authentication    = false
  encryption_at_host_enabled         = true
  generate_admin_password_or_ssh_key = false
  secure_boot_enabled                = false
  vtpm_enabled                       = false
  os_type                            = var.os_type
  sku_size                           = var.sku_size
  zone                               = 1

  bypass_platform_safety_checks_on_user_schedule_enabled = true
  patch_assessment_mode                                  = "AutomaticByPlatform"
  patch_mode                                             = "AutomaticByPlatform"

  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = local.snetvmId
        }
      }
    }
  }

  managed_identities = {
    user_assigned_resource_ids = [
      module.uai_msi_vm.resource_id,
    ]
  }

  os_disk = {
    caching = "ReadWrite"
    # storage_account_type = "Premium_LRS" # Requested but getting replaced (??) by standard after deployment
    storage_account_type = "Standard_LRS"
  }

  # source_image_reference = {
  #   publisher = "Canonical"
  #   offer     = "0001-com-ubuntu-server-jammy"
  #   sku       = "22_04-lts-gen2"
  #   version   = "latest"
  # }
  source_image_reference = var.source_image_reference

  tags = merge(var.base_tags, var.plan_tags)
}
#*/


