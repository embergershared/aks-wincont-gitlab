# 07_values.auto.tfvars

plan_tags = {
  Plan = "07-Jumpbox"
}

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
