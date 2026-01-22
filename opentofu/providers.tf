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
  api_token = var.virtual_environment_api_token
  endpoint  = var.virtual_environment_endpoint
  ssh {
    agent    = true
    username = "root"
  }
}


