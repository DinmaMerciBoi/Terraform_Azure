resource "azurerm_virtual_network" "dinma-vn" {
  name                = "dinma-network"
  resource_group_name = azurerm_resource_group.dinma-rg2.name
  location            = azurerm_resource_group.dinma-rg2.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_subnet" "dinma-subnet" {
  name                 = "dinma-subnet"
  resource_group_name  = azurerm_resource_group.dinma-rg2.name
  virtual_network_name = azurerm_virtual_network.dinma-vn.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_public_ip" "dinma-ip" {
  name                = "dinma-ip"
  resource_group_name = azurerm_resource_group.dinma-rg2.name
  location            = azurerm_resource_group.dinma-rg2.location
  allocation_method   = "Dynamic"

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_network_interface" "dinma-nic" {
  name                = "dinma-nic"
  location            = azurerm_resource_group.dinma-rg2.location
  resource_group_name = azurerm_resource_group.dinma-rg2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dinma-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dinma-ip.id
  }

  tags = {
    Environment = "dev"
  }
}