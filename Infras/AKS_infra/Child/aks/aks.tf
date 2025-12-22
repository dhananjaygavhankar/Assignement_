resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.rg_location
  resource_group_name = var.name_rg
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.vm2take
    # vnet_subnet_id = var.subnet_id
    vnet_subnet_id = var.aks_subnet_id

  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "Aks_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

#---------------------------------------------old tested code--------------------------
# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = var.cluster_name
#   location            = var.rg_location
#   resource_group_name = var.name_rg
#   dns_prefix          = var.dns_prefix

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size = var.vm2take
#     # orchestrator_version = var.o_version
#   }

#   network_profile {
#     network_plugin    = "azure"
#     network_policy    = "calico"
#     load_balancer_sku = "standard"
#   }

#   identity {
#     type = "SystemAssigned"
#   }
# }

# output "Aks_id" {
#   value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
# }