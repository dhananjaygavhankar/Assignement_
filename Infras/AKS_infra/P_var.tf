


# AKS and infra variables
variable "aks_vnet"{
  description = "Name of the AKS virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "subnet_name"{
  description = "Name of the AKS subnet"
  type        = string
  default     = "aks-subnet"
}

variable "cluster_name"{
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix"{
  description = "AKS DNS prefix"
  type        = string
}

variable "rg_location"{
  description = "Resource group location"
  type        = string
}

variable "name_rg"{
  description = "Resource group name"
  type        = string
}

variable "vm2take"{
  description = "VM size for AKS nodes"
  type        = string
}


# variable "name_rg" {}
# variable "rg_location" {}
# variable "vm2take" {}
# variable "cluster_name" {
#   description = "Name of the AKS cluster"
#   type        = string
# }
# variable "dns_prefix" {
#   description = "DNS prefix for the AKS cluster"
#   type        = string
# }


