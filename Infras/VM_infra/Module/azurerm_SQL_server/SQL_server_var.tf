variable "rg_nam"{}
variable "locatio"{}

variable "SQL_server" {}
variable "backend_subnet_id"{}
variable "sql_private_dns_zone_id"{
    type = list(string)
}
