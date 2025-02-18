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













# resource "azurerm_network_security_group" "dev-nsg" {
#   name                = "${azurerm_virtual_network.vnet.name}-${azurerm_subnet.dev.name}-nsg"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
# }

# resource "azurerm_subnet_network_security_group_association" "subnet" {
#   subnet_id                 = azurerm_subnet.dev.id
#   network_security_group_id = azurerm_network_security_group.dev-nsg.id
# }

# resource "azurerm_subnet" "dev" {
#   name                                      = "devSubnet"
#   resource_group_name                       = azurerm_resource_group.rg.name
#   virtual_network_name                      = azurerm_virtual_network.vnet.name
#   address_prefixes                          = ["10.0.4.0/24"]
#   private_endpoint_network_policies_enabled = false
# }

# resource "azurerm_network_interface" "compute" {

#   name                          = "${var.server_name}-nic"
#   location                      = var.location
#   resource_group_name           = var.resource_group_name
#   enable_accelerated_networking = var.enable_accelerated_networking

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = var.vnet_subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "compute" {

#   name                            = var.server_name
#   location                        = var.location
#   resource_group_name             = var.resource_group_name
#   size                            = var.vm_size
#   admin_username                  = var.admin_username
#   admin_password                  = var.admin_password
#   disable_password_authentication = var.disable_password_authentication //Set to true if using SSH key
#   tags                            = var.tags

#   network_interface_ids = [
#     azurerm_network_interface.compute.id
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = var.storage_account_type
#   }

#   source_image_reference {
#     publisher = var.os_publisher
#     offer     = var.os_offer
#     sku       = var.os_sku
#     version   = var.os_version

#   }

#   boot_diagnostics {
#     storage_account_uri = null
#   }
# }

