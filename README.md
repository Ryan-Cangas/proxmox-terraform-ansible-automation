# Proxmox Infrastructure as Code (IaC) & Automation

This repository provides an automated, reproducible workflow for provisioning and configuring homelab workloads on **Proxmox Virtual Environment** using **Terraform** and **Ansible**.

The setup transitions away from monolithic, pre-baked VM/CT clone templates in favor of direct standard OS tarball provisioning to keep base storage minimal and instances lightweight.

## Architecture & Technologies
* **Infrastructure Provisioning:** Terraform
* **Configuration Management:** Ansible
* **Hypervisor:** Proxmox VE (pve-server)
* **Container Layer:** Unprivileged/Privileged LXC Containers directly extracted from standard OS archives (Ubuntu 24.04)
* **Hardware Acceleration:** NVIDIA GPU Passthrough for media transcoding
* **Workload Services:** Docker & Docker Compose (Media Stack, AdGuard Home, Wazuh, etc.)
* **Networking:** Dynamic DHCP address assignment via local bridge (vmbr0)

## Provisioning Architecture
1. **Lightweight Base Deployments**: Instead of storing persistent 20GB+ clone templates. Terraform provisions containers directly from Proxmox CT templates (tar.zst files).
2. **Explicit Resource Baselines**: Each container is sized at code level with standard template allocation utilizing only 2 vCPU Cores, 2GB RAM, 1024 Swap, and 20GB Root Disk.
3. **Dynamic Cluster ID & DHCP**: Containers ID is not hardcoded and dynamically assigned, while IP is assigned via DHCP.
4. **Decoupled Data Volumes**: OS containers are decoupled from HDD mounting, since the homelab has very limited storage space, HDD-lvm-thin storages are mounted depending on the use case.
5. **Configuration Orchestration**: Ansible connects over SSH to install system packages, deploy Docker daemons, configure system daemonds (like freeing port 53 for AdGuard), and start Docker compose service stacks.

## Getting Started
1. **Prerequisites**
* Proxmox VE host reachable over local network or Tailscale
* Base OS template (Ubuntu or Debian tar.zst) downloaded on Proxmox already
* Terraform Version >=1.5.0
* Ansible

2. **Configure Environment Authentication**
 
    Export workstation-specific Proxmox API token and endpoint

    ```text
    export PROXMOX_VE_ENDPOINT="https://:8006"
    export PROXMOX_VE_API_TOKEN='terraform-user@pve!='
    export PROXMOX_VE_INSECURE="true"
     ```
3. **Deploy Infrastructure**

    ```text
    # Initialize provider plugins 
    terraform init

    # Review and apply execution plan
    terraform plan
    terraform apply
     ```

4. **Run Ansible Configuration0**

    Target provisioned container by resolved hostname or the dynamic IP:

    ```text
    # Method 1 (Dynamic IP)
    ansible-playbook -i "$(terraform-output -raw assigned_ip)," -u root media-stack.yml

    # Method 2 (Hostname)
    ansible-playbook -i inventory.ini pihole-playbook.yml
     ```


