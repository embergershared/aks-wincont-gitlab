output "bastion_rdp_cmd" {
  value = "az network bastion rdp --name ${local.hub_bastion_name} --resource-group ${local.hub_bastion_rg_name} --target-resource-id ${module.gitlab_runner_vm.resource_id} --configure"
}
# output "resources" {
#   value = data.azurerm_resources.lz_rg_resource_s.resources
# }
output "resource_name" {
  value = local.lz_vnet_name
}
