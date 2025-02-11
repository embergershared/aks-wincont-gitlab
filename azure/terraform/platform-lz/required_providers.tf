terraform {
  required_providers {
    # azuread = {
    #   # https://registry.terraform.io/providers/hashicorp/azuread/latest
    #   source  = "hashicorp/azuread"
    #   version = "~> 3.0"
    # }
    azurerm = {
      # https://registry.terraform.io/providers/hashicorp/azurerm/latest
      source  = "hashicorp/azurerm"
      version = "~> 4.7"
    }

    kubernetes = {
      # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
    helm = {
      # https://registry.terraform.io/providers/hashicorp/helm/latest
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }

    null = {
      # https://registry.terraform.io/providers/hashicorp/null/latest
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      # https://registry.terraform.io/providers/hashicorp/random/latest
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      # https://registry.terraform.io/providers/hashicorp/time/latest
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}
