# Terraform state
variable "tfStateStorageAccountName" {}
variable "containers" {
  type    = set(string)
  default = []
}
variable "authorized_ips" {
  type    = set(string)
  default = []
}

