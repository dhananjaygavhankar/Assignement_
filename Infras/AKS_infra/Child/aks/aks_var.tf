variable "cluster_name"{}
variable "dns_prefix"{}
variable "rg_location"{}
variable "name_rg"{}
variable "vm2take"{}
variable "aks_subnet_id"{}
variable "network_policy"{
  default = "calico"
}
variable "subnet_id"{
  description = "Subnet ID where AKS cluster will deploy"
  type        = string
}

# # variable "subnet_id{}
# variable "name_rg" {}
# variable "rg_location" {}
# variable "cluster_name" {}
# variable "dns_prefix" {}
# # variable "aks_vnet" {}
# variable "vm2take" {}
# # variable "o_version" {}
# # variable "subnet_name" {}