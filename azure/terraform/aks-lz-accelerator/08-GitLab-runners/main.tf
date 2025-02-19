locals {
  vnetLzId         = var.deployingAllInOne == true ? var.vnetLzId : data.azurerm_virtual_network.vnet-lz.0.id
  snetvmId        = var.deployingAllInOne == true ? var.snetvmId : data.azurerm_subnet.snet-vm.0.id
}

data "azurerm_virtual_network" "vnet-lz" {
  count               = var.deployingAllInOne == true ? 0 : 1
  name                = var.vnetLzName
  resource_group_name = var.rgLzName
}

data "azurerm_subnet" "snet-vm" {
  count                = var.deployingAllInOne == true ? 0 : 1
  name                 = "snet-vm"
  virtual_network_name = var.vnetLzName
  resource_group_name  = var.rgLzName
}

# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["gitlab"]
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
  os_type                            = "Linux"
  sku_size                           = "Standard_B2ms"
  zone                               = 1

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

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

