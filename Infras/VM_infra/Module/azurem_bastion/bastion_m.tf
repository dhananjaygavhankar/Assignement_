# resource "azurerm_subnet" "main" {
# name = "AzureBastionSubnet"
# resource_group_name = var.rg_nam
# virtual_network_name = var.vnet_name
# address_prefixes = var.bastion_subnet_address_prefixes
# }

resource "azurerm_bastion_host" "main" {  
name = "projectbastion"
location = var.locatio
resource_group_name =var.rg_nam

ip_configuration {
name = "configuration"
subnet_id = var.bastion_subnet
public_ip_address_id = var.bastion_ip
}
}