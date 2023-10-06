output "cluster_name" {
    value = data.azurerm_kubernetes_cluster.cluster.name
}

output "resource_group_name" {
    value = var.resource_group_name
}