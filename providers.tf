terraform {
  backend "s3" {
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.93.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.virtual_environment_endpoint
  ssh {
    agent    = true
    username = "root"
  }
}


