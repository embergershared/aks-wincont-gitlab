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

variable "speSubnetId" {
  type    = string
  default = ""
}

variable "dnszonesqlId" {
  type    = string
  default = ""
}

variable "akvName" {
  type    = string
  default = "akvlzti5y"
}

variable "akvId" {
  type    = string
  default = ""
}

variable "sql_admin_username" {
  type    = string
  default = "azsqladmin"
}
# variable "sql_admin_password" {
#   type = string
# }

variable "authorized_ips" {
  type    = set(string)
  default = []
}
