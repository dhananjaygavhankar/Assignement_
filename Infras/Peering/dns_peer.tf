
variable "peering_dns"{}


# Link AKS VNet to VM DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "aks_vm_dns_link" {
  name                  = "aks-link-to-${data.azurerm_private_dns_zone.this.name}"
  resource_group_name   = data.azurerm_resource_group.for_each.name
  # private_dns_zone_name = data.azurerm_private_dns_zone.this.name
  private_dns_zone_name = var.peering_dns
  virtual_network_id    = data.azurerm_virtual_network.aks_vnet.id
  registration_enabled  = false
}
