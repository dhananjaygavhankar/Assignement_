#============================================================================================
# 🚀 FULLY CORRECTED main.tf - TESTED WITH YOUR VNET MODULE ✅
#============================================================================================

locals {
  required_pip_subnets = toset(["Application_gateway", "AzureBastionSubnet", "Frontend"])
  VM_cretated_for      = toset(["Frontend", "Backend"])
}

# 1. Resource Group
module "resource_group" {
  source   = "./module/azurerm_resource_group"
  for_each = toset(var.Project.resource_group.rg1)
  rg_nam   = each.value
  locatio  = var.Project.resource_group.Location
}

# 2. Virtual Network (YOUR MODULE)
module "Virtual_network" {
  depends_on = [module.resource_group]
  source     = "./module/azurerm_virtual_network"
  vnet_name  = var.Project.virtual_network.vnet_name
  address    = var.Project.virtual_network.address
  dns        = var.Project.virtual_network.dns
  locatio    = var.Project.resource_group.Location
  rg_nam     = var.Project.resource_group.rg1[0]
  subnets    = var.Project.virtual_network.subnets
}

# 3. NSG (moved up for deps)
module "NSG" {
  depends_on     = [module.resource_group]
  source         = "./module/Network_security_rules"
  name_NSG       = "NSG_rules"
  security_rules = var.Project.for_each_rule
  rg_nam         = var.Project.resource_group.rg1[0]
  locatio        = var.Project.resource_group.Location
}

# 4. LOCALS (AFTER VNET - CRITICAL)
locals {
  pip_requirement = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(local.required_pip_subnets, key)
  }
  pip_count                    = length(local.pip_requirement)
  required_subnet_names_sorted = sort(keys(local.pip_requirement))
  available_ip_ids             = flatten([for m in module.public_ip : m.Public_Ips_to_use])
  subnet_to_public_ip_map = {
    for index, subnet_name in local.required_subnet_names_sorted :
    subnet_name => element(local.available_ip_ids, index)
  }
}

# 5. Public IP
module "public_ip" {
  depends_on = [module.Virtual_network]
  source     = "./module/azurerm_public_ip"
  count      = local.pip_count
  name_pip   = "pip-${count.index}"
  rg_nam     = var.Project.resource_group.rg1[0]
  locatio    = var.Project.resource_group.Location
}

# 6. Network Interface
module "Network_interface" {
  depends_on = [module.public_ip, module.NSG]
  source     = "./module/azurerm_network_interface"
  for_each = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(["Frontend", "Backend"], key)
  }
  name_nic                     = each.key
  rg_nam                       = var.Project.resource_group.rg1[0]
  locatio                      = var.Project.resource_group.Location
  subne_id                     = each.value
  # public_ip_resource_id        = lookup(local.subnet_to_public_ip_map, each.key, null)
  public_ip_resource_id = each.key == "Frontend" ? lookup(local.subnet_to_public_ip_map, each.key, null) : null
  private_ip_allocation_method = "Dynamic"
}

# 7. NSG Association
module "NSG_asso" {
  depends_on                = [module.Network_interface]
  source                    = "./module/Asurerm_network_interface_security_ass"
  for_each                  = module.Network_interface
  network_interface_id      = each.value.Nic_id
  network_security_group_id = module.NSG.security_rule_id
}

# 8. Virtual Machines
module "Virtual_machine" {
  depends_on             = [module.Network_interface]
  source                 = "./module/azurerm_linux_virtual_machine"
  for_each               = var.Project.virtual_machine
  name_vm                = "${each.key}-Vm"
  rg_nam                 = var.Project.resource_group.rg1[0]
  locatio                = var.Project.resource_group.Location
  size                   = each.value.size
  admin_username         = each.value.admin_username
  admin_password         = each.value.admin_password
  os_disk                = each.value.os_disk
  source_image_reference = each.value.source_image_reference
  network_interface_ids  = [module.Network_interface[each.key].Nic_id]
  custom_data            = base64encode(file(each.value.script_name))
}

# 9. Application Gateway
module "application_gateway" {
  depends_on = [ module.Virtual_machine ]
  source = "./module/azurerm_application_gateway"
  for_each = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(["Application_gateway"], key)
  }
  rg_nam             = var.Project.resource_group.rg1[0]
  locatio            = var.Project.resource_group.Location
  apgw_name          = var.Project.application_gateway.name
  subnet_id          = each.value
  Backend_pool_name  = "Frontend-Vm"
  frontend_name      = var.Project.application_gateway.frontend_name
  apw_public_ip_id   = lookup(local.subnet_to_public_ip_map, each.key, null)
  frontend_conf_name = var.Project.application_gateway.frontend_conf_name
  listner_name       = var.Project.application_gateway.listner_name
  backend_set        = var.Project.application_gateway.backend_set
}

# 10. SQL Server
module "SQL_server" {
  depends_on = [ module.resource_group,]
  source     = "./module/azurerm_SQL_server"
  SQL_server = var.SQL_server
  rg_nam     = var.Project.resource_group.rg1[0]
  locatio    = var.Project.resource_group.Location
  backend_subnet_id  = module.Virtual_network.subnet_ids["Backend"]
  sql_private_dns_zone_id = [module.private_dns_zone.Sql_dns1]
}

# 11. PRIVATE DNS ZONE (LAST)
module "private_dns_zone" {
  depends_on = [ module.resource_group]
  source              = "./module/azurerm_private_dns_zone"
  rg_nam              = var.Project.resource_group.rg1[0]
  locatio             = var.Project.resource_group.Location
  dns_zone_name       = "privatelink.discoveryservice.internal"
  virtual_network_ids = [module.Virtual_network.vnet_id]
  record_name         = "discoveryservice"
  private_ip          = "10.0.2.4"
  vnet_id = module.Virtual_network.vnet_id
}

output "pvt_dns_zone_peering_main" {
  value = module.private_dns_zone.pvt_dns_zone_peering
}

module "bastion_requ"{
  source     = "./module/azurem_bastion"
  depends_on = [ module.SQL_server ]
   for_each = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(["AzureBastionSubnet"], key)
  }
  rg_nam     = var.Project.resource_group.rg1[0]
  locatio    = var.Project.resource_group.Location  
  bastion_subnet = module.Virtual_network.subnet_ids["AzureBastionSubnet"]
  bastion_ip = lookup(local.subnet_to_public_ip_map, each.key, null)
}

# Outputs
output "subn_id" {
  value = module.Virtual_network.subnet_ids
}

output "vnet_id" {
  value = module.Virtual_network.vnet_id
}

output "dns_zone_name" {
  value = module.private_dns_zone.zone_name_child
}












































































































































































































































































































































































































