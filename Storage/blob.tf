terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

/*
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}
*/

resource "azurerm_resource_group" "dinma-rg" {
  name     = "dinma-rg"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "dinmastorage" #${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.dinma-rg.name
  location                 = azurerm_resource_group.dinma-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "dinma-tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}