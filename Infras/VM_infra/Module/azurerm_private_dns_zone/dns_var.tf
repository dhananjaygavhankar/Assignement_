variable "rg_nam" { type = string }
variable "locatio" { type = string }
variable "dns_zone_name" { type = string }
variable "virtual_network_ids" { type = list(string) }

# Make A record variables OPTIONAL
variable "record_name" { 
  type    = string 
  default = null 
}
variable "private_ip" { 
  type    = string 
  default = null 
}
variable "ttl" { 
  type    = number 
  default = 300 
}

variable "vnet_id" {
  description = "Virtual Network ID to link with Private DNS Zone"
  type        = string
}

# variable "rg_nam" { type = string }
# variable "locatio" { type = string }
# variable "dns_zone_name" { type = string }
# variable "virtual_network_ids" { type = list(string) }

# variable "zone_name" { type = string }
# variable "record_name" { type = string }
# variable "private_ip" { type = string }
# variable "ttl" { default = 300 }