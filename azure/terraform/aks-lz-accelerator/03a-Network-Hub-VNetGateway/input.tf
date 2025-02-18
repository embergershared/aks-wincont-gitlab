variable "location" {
  type    = string
  default = "eastus"
}

variable "rgHubName" {
  type    = string
  default = "AksTerra-AVM-Hub-RG"
}

variable "nsgHubDefaultName" {
  type    = string
  default = "nsg-default"
}

variable "nsgVMName" {
  type    = string
  default = "nsg-vm"
}
variable "hubVNETaddPrefixes" {
  type    = string
  default = "10.0.0.0/16"
}

variable "snetDefaultAddr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "snetFirewallAddr" {
  type    = string
  default = "10.0.1.0/26"
}

variable "snetBastionAddr" {
  type    = string
  default = "10.0.2.0/27"
}

variable "snetVMAddr" {
  type    = string
  default = "10.0.3.0/27"
}

variable "snetGatewayAddr" {
  type    = string
  default = "10.0.4.0/26"
}

variable "routeAddr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vnetHubName" {
  type    = string
  default = "vnet-hub"
}

variable "availabilityZones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "rtHubName" {
  type    = string
  default = "rt-hub-table"
}

variable "deployingAllInOne" {
  type    = bool
  default = false
}

variable "vnetHubId" {
  type        = string
  default     = ""
  description = "Should be value from output of 03-Network-Hub. Used only when deploying All-in-One scenario."
}

variable "localNetworkGatewayAddressSpace" {
  type    = string
  default = "172.16.0.0/24"
}

variable "localNetworkGatewayFqdn" {
  type    = string
  default = "localvpn.domain.com"
}

variable "sharedKey" {
  type    = string
  default = "xxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "speSubnetId" {
  type = string
  default = ""
}

variable "sku" {
  type = string
  default = "VpnGw1"
}