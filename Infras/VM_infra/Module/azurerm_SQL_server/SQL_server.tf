resource "azurerm_mssql_server" "main" {
  name                         = var.SQL_server
  resource_group_name          = var.rg_nam
  location                     = var.locatio
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"

#   azuread_administrator {
#     login_username = "AzureAD Admin"
#     object_id      = "00000000-0000-0000-0000-000000000000"
#   }
 public_network_access_enabled = false
}

resource "azurerm_mssql_database" "db" {
    depends_on = [ azurerm_mssql_server.main ]
  name      = azurerm_mssql_server.main.name
  server_id = azurerm_mssql_server.main.id
}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "sql-private-endpoint"
  location            = var.locatio
  resource_group_name = var.rg_nam
  subnet_id           = var.backend_subnet_id

  private_service_connection {
    name                           = "sql-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name = "sql-dns-group"

    private_dns_zone_ids = var.sql_private_dns_zone_id
  }
}

