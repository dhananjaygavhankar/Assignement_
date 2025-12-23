

module "rg" {
  source      = "./Child/rf"
  name_rg     = var.name_rg
  rg_location = var.rg_location
}

# Kubernates cluster creation 
module "aks" {
  source       = "./Child/aks"
  depends_on   = [module.rg, module.vnet]
  cluster_name = var.cluster_name
  dns_prefix   = var.dns_prefix
  rg_location  = var.rg_location
  name_rg      = var.name_rg
  vm2take      = var.vm2take

  # Pass the subnet ID from vnet module
  aks_subnet_id = module.vnet.aks_subnet_id
  subnet_id     = module.vnet.aks_subnet_id
}
module "acr" {
  source      = "./Child/Acr"
  depends_on  = [module.rg, module.aks]
  name_rg     = var.name_rg
  rg_location = var.rg_location
}

output "aks_child-id" {
  value = module.aks.Aks_id
}

resource "azurerm_role_assignment" "acr_pull" {
  depends_on           = [module.acr, module.aks]
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.Aks_id
}


#Vnet and Subnet creation
module "vnet" {
  depends_on  = [module.rg]
  source      = "./Child/vlan"
  name_rg     = var.name_rg
  rg_location = var.rg_location
  aks_vnet    = var.aks_vnet
  subnet_name = var.subnet_name

  # Pass these required values
  cluster_name  = var.cluster_name
  dns_prefix    = var.dns_prefix
  vm2take       = var.vm2take
  address_space = ["10.1.0.0/16"] # adjust as per your network design
}

output "Aks_vnet_id"{
  value = module.vnet.vnet_id
}

# module "vnet" {
#   source      = "./Child/vlan"
#   depends_on  = [module.rg]
#   name_rg     = var.name_rg
#   rg_location = var.rg_location
#   aks_vnet    = var.aks_vnet
#   subnet_name = var.subnet_name
# }