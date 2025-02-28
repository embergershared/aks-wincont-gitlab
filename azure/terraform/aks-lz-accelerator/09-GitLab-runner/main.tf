# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"

  suffix = ["gitlab"]
}
resource "random_password" "vm_password" {
  length  = 16
  special = true
  numeric = true
  lower   = true
  upper   = true
}
module "uai_mid_gitlab" {
  source           = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version          = "0.3.3"
  enable_telemetry = false

  name                = "uai-${module.naming.virtual_machine.name_unique}"
  location            = var.location # data.azurerm_resource_group.rg.location
  resource_group_name = var.rgLzName # data.azurerm_resource_group.rg.name

  tags = merge(var.base_tags, var.plan_tags)
}
module "gitlab_runner_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  #version = "0.17.0
  enable_telemetry = false

  admin_username                     = var.gl_runner_admin_username
  admin_password                     = random_password.vm_password.result
  disable_password_authentication    = false
  encryption_at_host_enabled         = true
  generate_admin_password_or_ssh_key = false
  location                           = var.location
  name                               = module.naming.virtual_machine.name_unique
  resource_group_name                = var.rgLzName
  os_type                            = var.os_type
  sku_size                           = var.sku_size
  zone                               = 1

  bypass_platform_safety_checks_on_user_schedule_enabled = true
  patch_assessment_mode                                  = "AutomaticByPlatform"
  patch_mode                                             = "AutomaticByPlatform"

  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = local.snetvmId
        }
      }
    }
  }

  managed_identities = {
    user_assigned_resource_ids = [
      module.uai_mid_gitlab.resource_id,
      local.sql_server_uai_id
    ]
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  # source_image_reference = {
  #   publisher = "Canonical"
  #   offer     = "0001-com-ubuntu-server-jammy"
  #   sku       = "22_04-lts-gen2"
  #   version   = "latest"
  # }
  source_image_reference = var.source_image_reference

  tags = merge(var.base_tags, var.plan_tags)
}
resource "azurerm_key_vault_secret" "this" {
  name         = "GitLabRunner-VM-Admin-Password"
  value        = random_password.vm_password.result
  key_vault_id = local.akvId
}
resource "azurerm_role_assignment" "acrpush_role_assignment" {
  scope                            = local.acrId
  role_definition_name             = "ACrPush"
  principal_id                     = module.uai_mid_gitlab.principal_id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "aksrbacclusteradmin_role_assignment" {
  scope                            = local.aksId
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = module.uai_mid_gitlab.principal_id
  skip_service_principal_aad_check = true
}


resource "azurerm_virtual_machine_extension" "glrunner_setup" {
  name                 = "glrunner_setup"
  virtual_machine_id   = module.gitlab_runner_vm.resource_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.gl_runner_script.rendered)}')) | Out-File -filepath Gitlab-runner-setup.ps1\" && powershell -ExecutionPolicy Unrestricted -File Gitlab-runner-setup.ps1 -GitLabRunnerToken ${data.template_file.gl_runner_script.vars.GitLabRunnerToken} -StAcctName ${data.template_file.gl_runner_script.vars.StAcctName} -StShareName ${data.template_file.gl_runner_script.vars.StShareName} -StAcctAccessKey ${data.template_file.gl_runner_script.vars.StAcctAccessKey}"
  }
  SETTINGS
}

# "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.gl_runner_script.rendered)}')) | Out-File -filepath Gitlab-runner-setup.ps1\" && powershell -ExecutionPolicy Unrestricted -File Gitlab-runner-setup.ps1 -GitLabRunnerToken ${data.template_file.gl_runner_script.vars.GitLabRunnerToken} -StorageAccountName ${data.template_file.gl_runner_script.vars.StorageAccountName} -StorageAccountFileShareName ${data.template_file.gl_runner_script.vars.StorageAccountFileShareName} -StorageAccountFileShareAccessKey ${data.template_file.gl_runner_script.vars.StorageAccountFileShareAccessKey}"
#    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.gl_runner_script.rendered)}')) | Out-File -filepath Gitlab-runner-setup.ps1\" && powershell -ExecutionPolicy Unrestricted -File Gitlab-runner-setup.ps1"

#*/
