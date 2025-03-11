variable "rgLzName" {
  type = string
}
variable "location" {
  type    = string
  default = "eastus2"
}

# TimeTracker specific variables
variable "time_tracker_ns_name" { default = "timetracker" }
variable "helm_release_name" {}
variable "docker_image_name" {}
variable "docker_image_tag" {}
variable "cs_kv_secret_name" {}
