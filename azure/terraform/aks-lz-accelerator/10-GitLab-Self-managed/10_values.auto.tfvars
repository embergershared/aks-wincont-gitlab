# 10_values.auto.tfvars

location   = "eastus2"
rgLzName   = "rg-use2-391575-s3-akswincont-avm-lz"
vnetLzName = "vnet-lz"

os_type  = "Linux"
sku_size = "Standard_B2ms"

source_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
  version   = "latest"
}
