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

variable "vnetHubName" {
  type    = string
  default = "vnet-hub"
}

variable "availabilityZones" {
  type    = list(string)
  default = ["1", "2", "3"]
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

variable "speSubnetId" {
  type = string
  default = ""
}