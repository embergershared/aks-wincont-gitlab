# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["lz"]
}

resource "random_password" "vm_password" {
  length  = 16
  special = true
  numeric = true
  lower   = true
  upper   = true
}

resource "azurerm_key_vault_secret" "this" {
  name         = "${module.naming.virtual_machine.name_unique}-password"
  value        = random_password.vm_password.result
  key_vault_id = local.akvId
}

module "jumpbox_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  #version = "0.17.0
  enable_telemetry = false

  location            = var.location
  resource_group_name = var.rgLzName
  os_type             = var.os_type
  name                = module.naming.virtual_machine.name_unique
  sku_size            = var.sku_size
  zone                = 1


  admin_username = var.jumpbox_admin_username
  admin_password = random_password.vm_password.result
  # disable_password_authentication    = false
  # encryption_at_host_enabled         = true
  # generate_admin_password_or_ssh_key = false
  # bypass_platform_safety_checks_on_user_schedule_enabled = true
  # patch_assessment_mode                                  = "AutomaticByPlatform"
  # patch_mode                                             = "AutomaticByPlatform"

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

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  data_disk_managed_disks = {
    disk1 = {
      name                 = "data-disk-lun0"
      storage_account_type = "Premium_LRS"
      lun                  = 0
      caching              = "ReadWrite"
      disk_size_gb         = 32
    }
  }

  source_image_reference = var.source_image_reference

  tags = merge(var.base_tags, var.plan_tags)
}
#*/


