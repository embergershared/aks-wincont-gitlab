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
variable "private_ingress_load_balancer_ip" {}

variable "cert_manager_ns_name" {}
variable "certificate_ca_issuer_name" {}
