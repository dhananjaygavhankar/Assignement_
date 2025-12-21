

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet
  location            = var.rg_location
  resource_group_name = var.name_rg
  address_space       = var.address_space
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.name_rg
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = var.address_space
}

output "subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.aks_vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.aks_vnet.name
}


output "aks_subnet_id" {
  value       = azurerm_subnet.aks_subnet.id
  description = "ID of the AKS subnet"
}


#-------------------------------old tested code ---------------------------
# resource "azurerm_virtual_network" "aks_vnet" {
#   name                = var.aks_vnet
#   location            = var.rg_location
#   resource_group_name = var.name_rg
#   address_space       = ["10.0.0.0/16"]
#   dns_servers         = ["10.0.0.4", "10.0.0.5"]

#   subnet {
#     name             = var.subnet_name
#     address_prefixes = ["10.0.1.0/24"]
#   }
# }

# # resource "azurerm_subnet" "aks_subnet" {
# #   name                 =var.subnet_name
# #   resource_group_name  = var.name_rg
# #   virtual_network_name = azurerm_virtual_network.aks_vnet.name
# #   address_prefixes       = ["10.0.1.0/24"]
# # }

# data "azurerm_subnet" "aks_subnet" {
#   name                 = var.subnet_name
#   virtual_network_name = azurerm_virtual_network.aks_vnet.name
#   resource_group_name  = var.name_rg
# }



# # output "subnet_id" {
# #   description = "ID of the AKS subnet defined inline within the virtual network"
# #   # value       = azurerm_virtual_network.aks_vnet.subnet[*].id[0]
# #   value       = azurerm_subnet.aks_subnet.id
# # }
