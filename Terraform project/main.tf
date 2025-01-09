data "azurerm_resource_group" "test" {
  name = var.resource_group_name
}

data "azurerm_subnet" "test" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# Public IP address for external access
resource "azurerm_public_ip" "example" {
  name                = "${var.vm_name}-public-ip"
  location            = data.azurerm_resource_group.test.location
  resource_group_name = data.azurerm_resource_group.test.name
  allocation_method   = "Static"
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "example" {
  name                = "${var.vm_name}-nsg"
  location            = data.azurerm_resource_group.test.location
  resource_group_name = data.azurerm_resource_group.test.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "${var.vm_name}-nic"
  location            = data.azurerm_resource_group.test.location
  resource_group_name = data.azurerm_resource_group.test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.test.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}


resource "azurerm_virtual_machine_extension" "install_python_vscode" {
  name                 = "install-python-and-vscode1"
  virtual_machine_id   = azurerm_windows_virtual_machine.example.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["https://chozhanscript.blob.core.windows.net/scriptpythonblob/install.ps1?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-12-29T12:41:40Z&st=2024-12-28T04:41:40Z&spr=https,http&sig=HZMFbfmuSIaguUCxF4huIqX2M%2FYtxtXqQOzYCKexqxE%3D"],
      "commandToExecute": "powershell.exe -ExecutionPolicy Bypass -File install.ps1"
    }
  SETTINGS
}

