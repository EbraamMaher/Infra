
variable "project_id" {
  #retreived from main directory
  type = string
  description = "The project ID to host the network in."
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


variable "region" {
  #retreived from main directory  
  type = string
  description = "The region to use"
}



variable "zone" {
  #retreived from main directory
  type = string
  description = "The zone where the Bastion host is located in."
}



variable "bastion_name" {
  #retreived from main directory
  type = string
  description = "The name to use for the bastion instance."
}