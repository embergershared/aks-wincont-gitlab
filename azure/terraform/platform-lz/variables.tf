variable "tenant_id" {}
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "location" {}
variable "location_short" {}
variable "base_name" {}

# / Resources within the Storage Account
variable "containers" { type = set(string) }
