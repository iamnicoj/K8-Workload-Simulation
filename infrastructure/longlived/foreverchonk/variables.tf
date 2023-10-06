variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to contain the AKS cluster"
}

variable "resource_group_location" {
  type        = string
  description = "The location of the new resource group to contain the AKS cluster"
}

variable "cluster_name" {
  type        = string
  description = "The name of the new AKS cluster"
}

variable "cluster_dns_prefix" {
  type = string
}

variable "default_node_pool" {
  description = "System node pool configuration for AKS cluster"
  type = object({
    name                = string
    vm_size             = string
    node_count          = optional(number)
    os_disk_size_gb     = optional(number)
    enable_auto_scaling = optional(bool)
    max_count           = optional(number)
    min_count           = optional(number)
  })
}

variable "litmus_node_pool" {
  description = "Litmus node pool configuration for AKS cluster"
  type = object({
    name                = string
    vm_size             = string
    node_count          = optional(number)
    os_disk_size_gb     = optional(number)
    enable_auto_scaling = optional(bool)
    max_count           = optional(number)
    min_count           = optional(number)
    node_labels         = map(string)
  })
}
