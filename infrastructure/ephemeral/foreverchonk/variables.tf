variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the AKS cluster"
}

variable "cluster_name" {
  type        = string
  description = "The name of the existing AKS cluster"
}

variable "extra_resource" {
  type        = bool
  default     = false
  description = "If set to true, it creates an extra resource group"
}

variable "extra_resource_group_name" {
  type        = string
  description = "The name of the extra resource group created"
  default     = ""
}

variable "extra_resource_location" {
  type        = string
  description = "This is the location of the new resource group"
  default     = ""
}

variable "ephemeral_node_pools" {
  description = "Ephemeral nodepool configuration"
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = optional(number)
    os_disk_size_gb     = optional(number)
    enable_auto_scaling = optional(bool)
    max_count           = optional(number)
    min_count           = optional(number)
    node_labels         = map(string)
  }))
  default = []
}