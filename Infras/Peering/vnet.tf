
resource "azurerm_virtual_network_peering" "aks_to_vm" {
  name                      = "aks-to-vm-peering"
  resource_group_name       = data.azurerm_resource_group.aks_rg.name
  virtual_network_name      = data.azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.for_each.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "vm_to_aks" {
  name                      = "vm-to-aks-peering"
  resource_group_name       = data.azurerm_resource_group.for_each.name
  virtual_network_name      = data.azurerm_virtual_network.for_each.name
  remote_virtual_network_id = data.azurerm_virtual_network.aks_vnet.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = false
}
