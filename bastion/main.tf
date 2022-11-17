
##local varaible
locals {
  #note: formate function acts same way as python 
  hostname = format("%s-bastion", var.bastion_name)
}

resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "vm-service-account-id"
  display_name = "Service Account"

}

resource "google_project_iam_binding" "container-admin" {
  project      = var.project_id
  role         = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

##create a firewall role that enables SSH to access the bastion VM

resource "google_compute_firewall" "bastion-ssh" {
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
  name          = format("%s-bastion-ssh", var.bastion_name)   #R-  Name of the resource. Provided by the client when the resource is created.Last character cannot be a dash.
  network       = var.network_name                             #R-  The name or self_link of the network to attach this firewall to.
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"] 

  allow {
    #O- The list of ALLOW rules specified by this firewall. 
    #Each rule specifies a protocol and port-range tuple that describes a permitted connection.
    protocol = "tcp"   #R- The protocol type is required when creating a firewall rule.(tcp, udp, icmp, esp, ah, sctp, ipip, all), or the IP protocol number
    ports    = ["22"]  #O- List of ports  [integer or a range] to which this rule applies. This field is only applicable for UDP or TCP protocol.
    ##Note if ports not specified, this rule applies to connections through any port.
  } 

}

resource "google_compute_firewall" "http" {
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
  name          = "http"  #R-  Name of the resource. Provided by the client when the resource is created.Last character cannot be a dash.
  network       = var.network_name                             #R-  The name or self_link of the network to attach this firewall to.
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"] 

  allow {
    
    protocol = "tcp"   
    ports    = ["80"]  
    
  } 
}




resource "google_compute_instance" "bastion" {
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
  name         = local.hostname
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id
  tags         = ["bastion"]

  boot_disk {                           #R- boot disk for the instance.
    
    initialize_params {                 #O- Either "initialize_params" or "source" must be set.
    
    /*The image from which to initialize this disk. This can be one of the image's :
    self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, 
    global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. 
    If referred by family, the images names must include the family name. If they don't, use the google_compute_image data source. 
    For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here. */
     
      image = "debian-cloud/debian-10"
    }

  }

#Allow the instance to be stopped by Terraform when updating configuration.
# it is required for [shielded_instance_config, service_account]
  allow_stopping_for_update = true

  shielded_instance_config {

    /*O- Enable Shielded VM on this instance. Shielded VM provides verifiable integrity to prevent against 
    malware and rootkits. 
    
    Defaults to disabled. Structure is documented below. 
    
    Note: shielded_instance_config can only be used with boot images with shielded vm support. 
    Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED 
    
    in order to update this field.*/

    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  

  
  network_interface {           #R- This can be specified multiple times.
    subnetwork = var.subnet_name
    access_config {
      # Not setting "nat_ip", use an ephemeral external IP.
      network_tier = "STANDARD"   #O- PREMIUM[default], FIXED_STANDARD or STANDARD
    }
  }

  
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # Note: allow_stopping_for_update must be set to true OR your instance must have a desired_status of TERMINATED 
    #in order to update this field.
    email  = google_service_account.service_account.email #O- The SA e-mail address. If not given, the default Google Compute Engine SA is used.
    scopes = ["cloud-platform"]                   #R- List of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope
  }


  scheduling {
    preemptible       = true   #O- If this field is set to true, then automatic_restart must be set to false. Defaults to false
    automatic_restart = false  #O-  restarte machine if it was terminated by Compute Engine (not a user). Defaults to true.
  }

}