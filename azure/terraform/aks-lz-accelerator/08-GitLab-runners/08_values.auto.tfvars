# values.auto.tfvars

location    = "eastus2"
rgLzName    = "rg-use2-391575-s3-akswincont-avm-lz"
vnetLzName  = "vnet-lz"

os_type     = "Windows"
sku_size    = "Standard_D4s_v3"
source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
}