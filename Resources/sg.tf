resource "azurerm_network_security_group" "dinma-sg" {
  name                = "dinma-sg"
  location            = azurerm_resource_group.dinma-rg2.location
  resource_group_name = azurerm_resource_group.dinma-rg2.name

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_network_security_rule" "dinma-rule" {
  name                        = "dinma-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dinma-rg2.name
  network_security_group_name = azurerm_network_security_group.dinma-sg.name
}

resource "azurerm_subnet_network_security_group_association" "dinma-sga" {
  subnet_id                 = azurerm_subnet.dinma-subnet.id
  network_security_group_id = azurerm_network_security_group.dinma-sg.id
}