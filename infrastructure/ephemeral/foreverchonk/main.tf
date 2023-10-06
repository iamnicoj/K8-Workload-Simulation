terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster_node_pool" "ephemeralpool" {
  # https://stackoverflow.com/a/67871267
  for_each = {for index,np in var.ephemeral_node_pools : np.name => np }
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.cluster.id
  name                  = each.value.name
  vm_size               = each.value.vm_size
  enable_auto_scaling   = each.value.enable_auto_scaling
  os_disk_size_gb       = each.value.os_disk_size_gb
  node_count            = each.value.node_count
  max_count             = each.value.max_count
  min_count             = each.value.min_count
  node_labels           = each.value.node_labels
}

resource "azurerm_resource_group" "newresourcegroup" {
  name     = var.extra_resource_group_name
  location = var.extra_resource_location
  count    = var.extra_resource ? 1 : 0
}