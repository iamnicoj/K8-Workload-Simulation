terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_dns_prefix

  default_node_pool {
    name                          = var.default_node_pool.name
    vm_size                       = var.default_node_pool.vm_size
    enable_auto_scaling           = var.default_node_pool.enable_auto_scaling
    node_count                    = var.default_node_pool.node_count
    max_count                     = var.default_node_pool.max_count
    os_disk_size_gb               = var.default_node_pool.os_disk_size_gb
    min_count                     = var.default_node_pool.min_count
    only_critical_addons_enabled  = true
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "litmus_node_pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  name                  = var.litmus_node_pool.name
  vm_size               = var.litmus_node_pool.vm_size
  enable_auto_scaling   = var.litmus_node_pool.enable_auto_scaling
  os_disk_size_gb       = var.litmus_node_pool.os_disk_size_gb
  node_count            = var.litmus_node_pool.node_count
  max_count             = var.litmus_node_pool.max_count
  min_count             = var.litmus_node_pool.min_count
  node_labels           = var.litmus_node_pool.node_labels
}
