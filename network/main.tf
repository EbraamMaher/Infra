/*=============VPC=============*/

resource "google_compute_network" "vpc" {
  name                            = local.network_name #R- 
  auto_create_subnetworks         = false              #O- to create subnet by me
  routing_mode                    = "GLOBAL"           #O- to advertise routes with all subnetworks of this network
  delete_default_routes_on_create = true               #O- default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false
}


/*=============Subnets=============*/
resource "google_compute_subnetwork" "subnet" {
  name                     = local.subnet_name               #R-
  ip_cidr_range            = "10.10.0.0/16"                  #R- Ranges must be unique and non-overlapping within a network. Only IPv4 is supported.
  region                   = var.region                      #O- the GCP region for this subnetwork.
  network                  = google_compute_network.vpc.name #R- The network this subnet belongs to. Only networks that are in the distributed mode can have subnetworks.
  private_ip_google_access = true                            #O-  When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.
}



/*=============Routes=============*/

/*A route is a rule that specifies how certain packets should be handled by the virtual network. 
Routes are associated with virtual machines by tag, and the set of routes for a particular virtual machine is called its routing table.
For each packet leaving a virtual machine, the system searches that virtual machine's routing table for a single best matching route.
*/

resource "google_compute_route" "egress_internet" {
  name             = "egress-internet"               #R- Name of the resource. Provided by the client when the resource is created.
  dest_range       = "0.0.0.0/0"                     #R- The destination range of outgoing packets that this route applies to. Only IPv4 is supported.
  network          = google_compute_network.vpc.name #R- the network that this route applies to....defined within this file
  next_hop_gateway = "default-internet-gateway"      #O- URL to a gateway that should handle matching packets. Currently, you can only specify the internet gateway, using a full or partial valid URL.Here I use the string option
  #project          =
}


/*=============Router=============*/

resource "google_compute_router" "router" {
  name    = "${local.network_name}-router"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.vpc.name
}

resource "google_compute_router_nat" "nat_router" {
  name                               = "${google_compute_subnetwork.subnet.name}-nat-router"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"



  subnetwork {
    name                    = google_compute_subnetwork.subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}

#locally defined variables for network resources
locals {
  network_name = "kubernetes-cluster"
  subnet_name  = "${google_compute_network.vpc.name}--subnet"


}
