#for network
variable "project_id" {
  type        = string
  description = "ID of the dedicated project"
}


variable "region" {
  type        = string
  description = "region to be used"
}
#

##for machine
variable "main_zone" {
  type        = string
  description = "The zone to use as primary"
}

variable "bastion_name" {
  type        = string
  description = "name of VM instance to be created"
}
##

###for cluster
variable "cluster_node_zones" {
  type        = list(string)
  description = "The zones where Kubernetes cluster worker nodes should be located"
}

# variable "service_account" {
#   type        = string
#   description = "The GCP service account"
# }

variable "cluster_master_ip_cidr_range" {
  type        = string
  description = "cider range for master cluster"
}

variable "cluster_pods_ip_cidr_range" {
  type        = string
  description = "cider range for pods"
}

variable "cluster_services_ip_cidr_range" {
  type        = string
  description = "cider range for services"
}
###