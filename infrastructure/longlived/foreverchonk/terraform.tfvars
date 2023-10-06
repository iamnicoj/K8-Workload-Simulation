resource_group_name = "scaleandoptimization-chonk"
resource_group_location = "eastus2"

cluster_name = "foreverchonk"
cluster_dns_prefix = "foreverchonk"

default_node_pool = {
    "name": "default",
    "vm_size": "Standard_D16s_v5",
    "enable_auto_scaling": "true",
    "os_disk_size_gb": 32,
    "node_count": 1,
    "max_count": 3,
    "min_count": 1
}

litmus_node_pool = {
    "name": "litmus",
    "vm_size": "Standard_D32s_v3",
    "enable_auto_scaling": "true",
    "os_disk_size_gb": 32,
    "node_count": 1,
    "max_count": 3,
    "min_count": 1,
    "node_labels": {
        "mode": "chaos"
    }
}