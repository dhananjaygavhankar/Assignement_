# Variables
# variable "aks_vnet_id" { type = string }
# variable "vm_dns_zone_name" { type = string }
# variable "vm_rg_name" { type = string }

# Link AKS VNet to VM DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "aks_vm_dns_link" {
  name                  = "aks-link-to-${data.azurerm_private_dns_zone.this.name}"
  resource_group_name   = data.azurerm_resource_group.aks_rg.name
  private_dns_zone_name = data.azurerm_private_dns_zone.this.name
  virtual_network_id    = data.azurerm_virtual_network.aks_vnet.id
  registration_enabled  = false
}
