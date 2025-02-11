resource "azurerm_resource_group" "rg_platform" {
  name     = "rg-${var.location_short}-${var.base_name}-platform-lz"
  location = var.location
}

