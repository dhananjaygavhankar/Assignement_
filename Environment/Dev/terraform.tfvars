# Resource Group Variables
name_rg     = "aks_r"
rg_location = "eastus"


# AKS Cluster Variables
cluster_name = "g15-aks-cluster"
dns_prefix   = "g15akscluster"
vm2take      = "Standard_DC2s_v3" #"Standard_D2lds_v6" #"standard_F2"



Project = {

  #================== for resource Group requirement==================
  resource_group = {
    rg1      = ["vm_infra_rg"]
    Location = "centralindia"
  }

  #===================for virtual Network & subnet requirement========  
  virtual_network = {
    vnet_name = "4_each_vnet"
    address   = ["10.0.0.0/16"]
    dns       = ["10.0.0.4", "10.0.0.5"]
    #_____***_______add your sunbet_______****___________
    subnets = {
      s1 = {
        name           = "Frontend"
        subnet_address = ["10.0.1.0/24"]
      }
      s2 = {
        name           = "Backend"
        subnet_address = ["10.0.2.0/24"]
      }
      s3 = {
        name           = "AzureBastionSubnet"
        subnet_address = ["10.0.3.0/26"]
      }
      s4 = {
        name           = "Application_gateway"
        subnet_address = ["10.0.4.0/24"]
      }
    }
    #______***_______________________________****________
  }
  #===============for NSG rules requirement=================================
  for_each_rule = {
    R1 = {
      name                       = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"

    }
    R2 = {
      name                       = "allow-http"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"

    }
  }
  #=============== For linux Virtual Machin requirement =================================
  virtual_machine = {
    Frontend = {
      name           = "Frontend"
      size           = "Standard_D2ls_v5"
      admin_username = "adminuser"
      admin_password = "Admin@12345678"
      script_name    = ".nginx.sh"
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
    }
    Backend = {
      name           = "Backend"
      size           = "Standard_D2ls_v5"
      admin_username = "adminuser"
      admin_password = "Admin@12345678"
      script_name    = ".nginx.sh"
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
    }
  }
  application_gateway = {
    name               = "Ramsetu"
    frontend_name      = "Port_frontend"
    frontend_conf_name = "Port_conf_frontend"
    listner_name       = "apg_listner"
    backend_set        = "apg"
  }
}

SQL_server = "dhanajaysqlserver"
