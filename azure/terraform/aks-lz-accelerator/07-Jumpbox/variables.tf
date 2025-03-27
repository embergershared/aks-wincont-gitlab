variable "rgHubName" {
  type = string
}
variable "rgLzName" {
  type    = string
  default = "AksTerra-AVM-LZ-RG"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vnetLzName" {
  type    = string
  default = "vnet-lz"
}

variable "vnetHubName" {
  type    = string
  default = "vnet-hub"
}

variable "deployingAllInOne" {
  type    = bool
  default = false
}

variable "vnetLzId" {
  type    = string
  default = ""
}

variable "snetvmId" {
  type    = string
  default = ""
}

variable "jumpbox_admin_username" {
  type    = string
  default = "azureuser"
}

variable "jumpbox_admin_password" {
  type = string
}

variable "os_type" {
  type    = string
  default = "Windows"
}

variable "sku_size" {
  type    = string
  default = "Standard_D4s_v3"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}

variable "msft_entra_id_group_name" {}
variable "hww_entra_id_group_name" {}
variable "private_dns_zone_name" {}
