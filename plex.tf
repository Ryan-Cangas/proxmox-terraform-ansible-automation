resource "proxmox_virtual_environment_container" "plex" {
  description = "Managed by Terraform - Media Stack (Plex, Jellyfin, qBittorrent)"
  node_name   = "pve-server"
  vm_id       = 110

  clone {
    vm_id = 9000
  }

  initialization {
    hostname = "plex-srv"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  features {
    nesting = true # Required for Docker to run inside LXC
    keyctl  = true # Required for Docker container key management
  }

  # Leave stopped so mountpoints and host device permissions can be set
  started = false
}
