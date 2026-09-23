resource "proxmox_virtual_environment_container" "pihole" {
  description = "Managed by Terraform - Pi-hole DNS Sinkhole"
  node_name   = "pve-server"
  vm_id       = 202

  clone {
    vm_id = 9000 # Your lightweight base template
  }

  initialization {
    hostname = "pihole"

    ip_config {
      ipv4 {
        address = "192.168.1.63/24" # Check if IP available!
        gateway = "192.168.1.1"    
      }
    }

    user_account {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@machine"
      ]
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  features {
    nesting = true # Required for Docker
    keyctl  = true
  }

  started = true
}
