resource "proxmox_virtual_environment_container" "pihole" {
  description = "Managed by Terraform - Pi-hole DNS Sinkhole"
  node_name   = "pve-server"
  vm_id       = 202

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    type             = "ubuntu"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
    swap      = 1024
  }

  initialization {
    hostname = "pihole"
    ip_config {
      ipv4 {
        address = "192.168.1.63/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4Ufo6Vmb4GUXZou+/2NYcvmomJl9uv+vJ1K2B4mhQR ryan-rtx"
      ]
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  features {
    nesting = true
    keyctl  = true
  }

  started = true
}