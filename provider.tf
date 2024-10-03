terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.32.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.53.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

/*
provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = var.devstack_adm_password
  auth_url    = "https://${google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip}/identity/v3"
  region      = "RegionOne"
  insecure    = true
}
*/
