# 07_values.auto.tfvars

plan_tags = {
  Plan = "07-Jumpbox"
}

rgLzName   = "rg-use2-391575-s3-akswincont-avm-lz"
vnetLzName = "vnet-lz"

# os_type  = "Windows"
# sku_size = "Standard_B2s"

# source_image_reference = {
#   publisher = "MicrosoftWindowsDesktop"
#   offer     = "Windows-11"
#   sku       = "win11-24h2-pro"
#   version   = "latest"
# }

jumpbox_admin_username = "jumpadmin"


os_type  = "Windows"
sku_size = "Standard_F16s_v2"

source_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2025-datacenter-g2"
  version   = "latest"
}

msft_entra_id_group_name = "HWW AKS PoC - MSFT team"
hww_entra_id_group_name  = "HWW AKS PoC - Hilton team"
private_dns_zone_name    = "private.contoso.com"
