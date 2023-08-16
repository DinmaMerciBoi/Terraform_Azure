terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
  /*
  backend "azurerm" {
    resource_group_name  = "dinma-rg"
    storage_account_name = "dinmastorage"
    container_name       = "dinma-tfstate"
    key                  = "terraform.tfstate"
  } */
}
/*
Storage access key must retrieved and saved for the backend to be configured. Run this command:
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
*/


provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "dinma-rg2" {
  name     = "dinma-rg2"
  location = "East US"
  tags = {
    Environment = "dev"
  }
}

data "azurerm_public_ip" "dinma-ip-data" {
  name                = azurerm_public_ip.dinma-ip.name
  resource_group_name = azurerm_resource_group.dinma-rg2.name
}

output "instance_ip_address" {
  value = "${azurerm_linux_virtual_machine.My-Server.name}: ${data.azurerm_public_ip.dinma-ip-data.ip_address}"
}