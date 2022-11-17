provider "google" {
  
  project = var.project_id
  region  = var.region    
  zone    = var.main_zone 
}

##calling the newtwork module giving it a name google_networks
module "google_networks" {
  source = "./network"

  project_id = var.project_id
  region     = var.region
}

##calling the bastion module giving it a name bastion and network config.
module "bastion" {
  source = "./bastion"

  project_id = var.project_id
  region     = var.region

  network_name = module.google_networks.network.name
  subnet_name  = module.google_networks.subnet.name

  zone         = var.main_zone
  bastion_name = var.bastion_name
}



##calling the kuberenetes module giving it a SA,node zones and network config[including cider ranges for master,pods,services and machine IP].
module "google_kubernetes_cluster" {
  source = "./kubernetes_cluster"

  project_id = var.project_id
  region     = var.region

  node_zones = var.cluster_node_zones
  #service_account = var.service_account

  network_name = module.google_networks.network.name
  subnet_name  = module.google_networks.subnet.name

  master_ipv4_cidr_block     = var.cluster_master_ip_cidr_range
  pods_ipv4_cidr_block       = var.cluster_pods_ip_cidr_range
  services_ipv4_cidr_block   = var.cluster_services_ip_cidr_range
  authorized_ipv4_cidr_block = "${module.bastion.ip}/32" #bastion IP to be putted in authorized networks
}

