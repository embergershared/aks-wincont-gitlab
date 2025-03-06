output "bastion_rdp_cmd" {
  value = "az network bastion rdp --name ${local.hub_bastion_name} --resource-group ${local.hub_bastion_rg_name} --target-resource-id ${module.jumpbox_vm.resource_id} --configure"
}
