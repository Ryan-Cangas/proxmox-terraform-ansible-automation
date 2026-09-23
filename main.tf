terraform {
  required_version = ">= 1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.60.0"
    }
  }
}

provider "proxmox" {
  insecure = false
}

# Queries available nodes
data "proxmox_virtual_environment_nodes" "available_nodes" {}

output "proxmox_nodes" {
  description = "Connected Proxmox node names:"
  value       = data.proxmox_virtual_environment_nodes.available_nodes.names
}

