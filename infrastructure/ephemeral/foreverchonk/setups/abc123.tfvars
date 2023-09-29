ephemeral_node_pools = [
    {
        "name": "ephemeral1",
        "vm_size": "Standard_D32s_v4",
        "enable_auto_scaling": "true",
        "os_disk_size_gb": 32,
        "node_count": 1
        "max_count": 6,
        "min_count": 1,
        "node_labels": {
            "mode": "ephemeral"
        }
    },
]

extra_resource = true
extra_resource_group_name = "scaleandoptimization-extrargname"
extra_resource_location = "eastus2"