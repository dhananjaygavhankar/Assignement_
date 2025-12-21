data "azurerm_resource_group" "aks_rg"{
    name = "aks_r"
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
}

data "azurerm_resource_group""for_each"{
    name = "4_each"
}
data "azurerm_virtual_network" "for_each" {
          name = "4_each_vnet"
           resource_group_name =data.azurerm_resource_group.for_each.name
}
data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.discoveryservice.internal"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
}
