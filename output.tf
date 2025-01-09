# Output Public IP Address
output "public_ip_address" {
  value = azurerm_public_ip.example.ip_address
}

# Output Resource Group Name

# Output VM ID
output "vm_id" {
  value = azurerm_windows_virtual_machine.example.id
}
