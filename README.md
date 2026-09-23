# Proxmox Infrastructure as Code (IaC) & Automation

This repository demonstrates a fully automated, reproducible home data center deployment using **Terraform** and **Ansible** against a **Proxmox Virtual Environment**.

## Architecture & Technologies
* **Infrastructure Provisioning:** Terraform
* **Configuration Management:** Ansible
* **Hypervisor:** Proxmox VE (LXC Containers)
* **Container Orchestration:** Docker & Docker Compose
* **Hardware Acceleration:** NVIDIA GPU Passthrough for media transcoding

## How It Works
1. **Terraform** provisions lightweight, unprivileged LXC containers (~20GB OS) from a base template in seconds, configuring networking (DHCP) and enabling nested virtualization features.
2. Large datasets (e.g., 1TB media drives) are handled via decoupled Proxmox bind mounts, keeping the infrastructure state fast and stateless.
3. **Ansible** connects via SSH to install dependencies, configure the NVIDIA Container Toolkit, provision directories, and deploy a decoupled Docker Compose stack (Plex, Jellyfin, qBittorrent).

## Deployment
```text
bash
terraform init
terraform apply
ansible-playbook -i inventory.ini media-stack.yml
```
