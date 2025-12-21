
resource "azurerm_virtual_network" "for_each" {
  name                = var.vnet_name
  location            = var.locatio
  resource_group_name = var.rg_nam
  address_space       = var.address
  dns_servers         = var.dns

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefixes = subnet.value.subnet_address
    }
  }
}

# ✅ FIXED OUTPUTS - Use correct syntax
output "vnet_id" {
  value = azurerm_virtual_network.for_each.id
}

output "subnet_ids" {
  value = {for sub in azurerm_virtual_network.for_each.subnet: sub.name => sub.id}
}

output "subnet_id_map" {
  value = {for sub in azurerm_virtual_network.for_each.subnet: sub.name => sub.id}
}



































































































































































































#value = {for sub in azurerm_virtual_network.for_each.subnet: sub.name => sub.id}

#---------------------------------------------
# output "subnet_ids" {
#   value = {
#     for idx, subnet_config in var.subnets : 
#     subnet_config.name => azurerm_virtual_network.for_each.subnet[idx].id
#   }
# }

# output "subnet_id_map" {
#   value = { for k, v in var.subnets : v.name => azurerm_virtual_network.for_each.subnet[k].id }
# }
#-------------------------------------------------------
# resource "azurerm_virtual_network" "for_each" {
#   # for_each = var.nic
#   name                = var.vnet_name
#    location            = var.locatio
#   resource_group_name = var.rg_nam
#   address_space       = var.address
#   dns_servers         = var.dns

#     dynamic "subnet" {
#       for_each = var.subnets
#       content {
#     name             = subnet.value.name
#     address_prefixes = subnet.value.subnet_address
#   }
#   }
# }

# output "subnet_ids"{
#   value = {for sub in azurerm_virtual_network.for_each.subnet: sub.name => sub.id}
# }