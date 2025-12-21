# variables.tf

variable "aks_vnet" {
  description = "Name of the AKS virtual network"
  type        = string
  default     = "aks-vnet"   # You can change to your preferred name
}

variable "subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "aks-subnet" # You can change to your preferred name
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "AKS DNS prefix"
  type        = string
}


variable "vm2take" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "name_rg" {}
variable "rg_location" {}
variable "address_space" {} # optional


# variable "aks_vnet" {}
# variable "subnet_name" {}
# variable "name_rg" {}
# variable "rg_location" {}
# variable "subnet_id"{}
