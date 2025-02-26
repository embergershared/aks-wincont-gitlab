# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["lz"]
}

module "jumpbox_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  #version = "0.17.0
  admin_username                     = var.jumpbox_admin_username
  admin_password                     = var.jumpbox_admin_password
  disable_password_authentication    = false
  enable_telemetry                   = false
  encryption_at_host_enabled         = true
  generate_admin_password_or_ssh_key = false
  location                           = var.location
  name                               = module.naming.virtual_machine.name_unique
  resource_group_name                = var.rgLzName
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

  os_disk = {
    caching              = "ReadWrite"
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

