variable "project_id" {
  #retreived from main directory
  type = string
  description = "The project ID to host the network in."
}

variable "region" {
  #retreived from main directory  
  type = string
  description = "The region to use"
}

variable "node_zones" {
  type = list(string)
  description = "The zones where worker nodes are located"
}

variable "network_name" {
  ##retrieved form network module
  type = string
  description = "The name of the network that should be used."
}

variable "subnet_name" {
  ##retrieved form network module
  type = string
  description = "The name of the subnet that should be used."
}




# variable "service_account" {
#   type = string
#   description = "The service account to use"
# }

variable "pods_ipv4_cidr_block" {
  type = string
  description = "The CIDR block to use for pod IPs"
}

variable "services_ipv4_cidr_block" {
  type = string
  description = "The CIDR block to use for the service IPs"
}

variable "authorized_ipv4_cidr_block" {
  type = string
  description = "The CIDR block where HTTPS access is allowed from"
  default = null
}

variable "master_ipv4_cidr_block" {
  type = string
  description = "The /28 CIDR block to use for the master IPs"
}