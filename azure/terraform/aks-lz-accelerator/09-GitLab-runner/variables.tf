variable "rgHubName" {
  type    = string
  default = "AksTerra-AVM-Hub-RG"
}

variable "rgLzName" {
  type    = string
  default = "AksTerra-AVM-LZ-RG"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vnetLzName" {
  type    = string
  default = "vnet-lz"
}

variable "vnetHubName" {
  type    = string
  default = "vnet-hub"
}

variable "acrName" {
  type    = string
  default = "acrlzti5y"
}

variable "akvName" {
  type    = string
  default = "akvlzti5y"
}

variable "aksName" {
  type    = string
  default = "akvlzti5y"
}

variable "deployingAllInOne" {
  type    = bool
  default = false
}

variable "vnetLzId" {
  type    = string
  default = ""
}

variable "snetvmId" {
  type    = string
  default = ""
}

variable "gl_runner_admin_username" {
  type    = string
  default = "azureuser"
}

# variable "gl_runner_admin_password" {
#   type = string
# }

variable "os_type" {
  type    = string
  default = "Windows"
}

variable "sku_size" {
  type    = string
  default = "Standard_D4s_v3"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}


variable "acrId" {
  type    = string
  default = ""
}

variable "akvId" {
  type    = string
  default = ""
}

variable "aksId" {
  type    = string
  default = ""
}

variable "gitlab_runner_token" {
  type      = string
  sensitive = true
}
