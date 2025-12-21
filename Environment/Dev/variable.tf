


# AKS and infra variables
variable "aks_vnet" {
  description = "Name of the AKS virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "aks-subnet"
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "AKS DNS prefix"
  type        = string
}

variable "rg_location" {
  description = "Resource group location"
  type        = string
}

variable "name_rg" {
  description = "Resource group name"
  type        = string
}

variable "vm2take" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "Project" {
  description = "variable should be nested"
  type = object({ # <-- 1. Start of Project object
    resource_group = object({
      rg1        = list(string)
      Location   = string
      managed_by = optional(string)
      tags       = optional(string)
    })
    virtual_network = object({
      vnet_name = string
      address   = list(string)
      dns       = list(string)
      subnets = map(object({
        name           = string
        subnet_address = list(string)
      }))
    })
    for_each_rule = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
    virtual_machine = map(object({
      name                  = string
      size                  = string
      admin_username        = string
      admin_password        = string
      script_name           = string
      network_interface_ids = optional(list(string))
      os_disk = object({
        caching              = string
        storage_account_type = string
      })
      source_image_reference = object({
        publisher = string
        offer     = string
        sku       = string
        version   = string
      })
    }))
    application_gateway = object({
      name               = string
      frontend_name      = string
      frontend_conf_name = string
      listner_name       = string
      backend_set        = string
    })
  })
}

variable "SQL_server" {}