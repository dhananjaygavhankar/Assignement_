# Private DNS Zone
resource "azurerm_private_dns_zone" "this" {
  name                = var.dns_zone_name
  resource_group_name = var.rg_nam
  tags = {
    Environment = "Production"
  }
}

output "pvt_dns_zone_peering" {
  value = azurerm_private_dns_zone.this.name
}

# VNet Links
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count               = length(var.virtual_network_ids)
  name                = "link-vnet-${count.index}-to-${var.dns_zone_name}"
  resource_group_name = var.rg_nam
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id = var.virtual_network_ids[count.index]
  registration_enabled  = false
}

# A Record - FIXED REFERENCE
resource "azurerm_private_dns_a_record" "this" {
  count               = var.record_name != null && var.private_ip != null ? 1 : 0
  name                = var.record_name
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.rg_nam
  ttl                 = var.ttl
  records             = [var.private_ip]
}

output "zone_name_child" { value = azurerm_private_dns_zone.this.name }
output "zone_id" { value = azurerm_private_dns_zone.this.id }
output "a_record_fqdn" { value = length(azurerm_private_dns_a_record.this) > 0 ? azurerm_private_dns_a_record.this[0].fqdn : null }# Private DNS Zone
# Add optional output for SQL DNS zone name (already have ID)




resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.rg_nam
}
output "Sql_dns1"{
  value = azurerm_private_dns_zone.sql_dns.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  depends_on = [ azurerm_private_dns_zone.sql_dns ]
  name                  = "sql-dns-link"
  resource_group_name   = var.rg_nam
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}