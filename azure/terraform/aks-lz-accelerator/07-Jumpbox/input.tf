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
  type = string
  default = ""
}

variable "snetvmId" {
  type = string
  default = ""
}

variable "jumpbox_admin_username" {
  type    = string
  default = "azureuser"
}

variable "jumpbox_admin_password" {
  type    = string
}