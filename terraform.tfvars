project_id = "gproject-368612"
region     = "europe-west3"
main_zone  = "europe-west3-b"

bastion_name       = "bastion-vm"
cluster_node_zones = ["europe-west3-b"]


cluster_master_ip_cidr_range   = "10.100.100.0/28"
cluster_pods_ip_cidr_range     = "10.101.0.0/16"
cluster_services_ip_cidr_range = "10.102.0.0/16"



