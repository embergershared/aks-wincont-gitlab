# 09_values.auto.tfvars

plan_tags = {
  Plan = "09-GitLab-runner"
}

rgLzName   = "rg-use2-391575-s3-akswincont-avm-lz"
vnetLzName = "vnet-lz"

gl_runner_admin_username = "glRunnerAdmin"

os_type  = "Windows"
sku_size = "Standard_F16s_v2"

source_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2025-datacenter-g2"
  version   = "latest"
}
