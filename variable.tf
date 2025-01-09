variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "Devops"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "ExampleVM"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "myfirst-vnet"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "default"
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "MyAzureVM"
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
  default     = "Test@12345"
}
variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "centralindia"
}
