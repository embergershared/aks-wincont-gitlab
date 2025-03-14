variable "rgHubName" {
  type = string
}

variable "rgLzName" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "private_ingress_controller_ns_name" {}

variable "private_dns_zone_name" {}

