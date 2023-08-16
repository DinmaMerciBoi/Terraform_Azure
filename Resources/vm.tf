resource "azurerm_linux_virtual_machine" "My-Server" {
  name                  = "Dinma-Server"
  resource_group_name   = azurerm_resource_group.dinma-rg2.name
  location              = azurerm_resource_group.dinma-rg2.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.dinma-nic.id]

  custom_data = filebase64("install.sh")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/Azure_Terraform/Resources/dinmakey.pub") #key is created with ssh-keygen command
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}