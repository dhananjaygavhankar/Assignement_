resource "azurerm_resource_group" "aks_rg"{
    name     = var.name_rg
    location = var.rg_location
}