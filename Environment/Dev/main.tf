module "vm_infra" {
  depends_on  = [module.Aks_infra]
  source      = "../../infras/VM_infra"
  Project     = var.Project
  SQL_server  = var.SQL_server
  vnet_aks_id = module.Aks_infra.Aks_vnet_id

}

module "Aks_infra" {
  source       = "../../infras/AKS_infra"
  aks_vnet     = var.aks_vnet
  subnet_name  = var.subnet_name
  cluster_name = var.cluster_name
  dns_prefix   = var.dns_prefix
  rg_location  = var.rg_location
  name_rg      = var.name_rg
  vm2take      = var.vm2take
}

module "Pair" {
  depends_on  = [module.Aks_infra, module.vm_infra]
  source      = "../../infras/Peering"
  peering_dns = module.vm_infra.pvt_dns_zone_peering_main
  dns_name    = module.vm_infra.dns_zone_name
}

# Outputs
output "subn_id1" {
  value = module.vm_infra.subn_id
}

output "vnet_vm_id" {
  value = module.vm_infra.vnet_id
}
output "vnet_aks_id" {
  value = module.Aks_infra.Aks_vnet_id
}

output "dns_zone_name1" {
  value = module.vm_infra.dns_zone_name
}

output "pvt_dns_zone_peering_main" {
  value = module.vm_infra.pvt_dns_zone_peering_main
}