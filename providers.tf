terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.azure-subscription-id
  client_id       = var.azure-client-id
  # client_secret                     = "..."
  client_certificate_path     = var.client-certificate-path
  client_certificate_password = var.client-certificate-password
  tenant_id                   = var.azure-tenant-id
}
