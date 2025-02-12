variable "tenant_id" {}
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}


# Terraform state
variable "tfStateStorageAccountName" {}
variable "containers" { type = set(string) }
