-------------------------------------------
pct exec 1001 -- passwd flowise
pct exec <container_id> -- bash /path/to/script.sh
pct exec 1002 -- bash /root/scripts/install.sh --option1 --option2
pct exec <vmid> [<extra-args>] [OPTIONS]
----------------------------------------------
----------------------
dpkg -l | grep nvidia
apt search nvidia-driver
-------------------------------------
/etc/pve/lxc
ls -l /dev/dri

cat /etc/group

nano /etc/subgid
Paste at the bottom, for example:

root:44:1
root:104:1
----------------------------------
arch: amd64
cores: 2
cpulimit: 2
features: nesting=1
hostname: test-gpu-04
memory: 3000
net0: name=eth0,bridge=vmbr0,firewall=1,hwaddr=BC:24:11:06:18:78,ip=dhcp,type=veth
ostype: debian
rootfs: local-lvm:vm-104-disk-0,size=20G
swap: 512
unprivileged: 1
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
lxc.idmap: u 0 100000 65536
lxc.idmap: g 0 100000 44
lxc.idmap: g 44 44 1
lxc.idmap: g 45 100045 62
lxc.idmap: g 107 104 1
lxc.idmap: g 108 100108 65428


usermod -aG render,video root
Install Docker, run apps, even change your LXC for a Linux Desktop!!!
------------------------------------------------------------------------
----------------------------------------------------------------
------------------------------------------------------------------------


#!/bin/bash

# Function to create directories if they don't exist
create_directories() {
  mkdir -p ansible/roles/container_setup/tasks
  mkdir -p ansible/roles/container_setup/templates
  mkdir -p ansible/roles/ollama_flowise/tasks
  mkdir -p ansible/roles/ollama_flowise/templates
}

# Function to create the inventory file
create_inventory_file() {
  cat <<EOF > ansible/inventory
[proxmox]
proxmox_host ansible_host=your_proxmox_host ansible_user=root
EOF
}

# Function to create the playbook file
create_playbook_file() {
  cat <<EOF > ansible/playbook.yml
---
- hosts: proxmox
  become: yes
  roles:
    - role: container_setup
    - role: ollama_flowise
EOF
}

# Function to create the container_setup role main task file
create_container_setup_tasks() {
  cat <<EOF > ansible/roles/container_setup/tasks/main.yml
---
- name: Create LXC containers
  command: >
    pct create {{ item.id }} local:vztmpl/debian-10-standard_10.7-1_amd64.tar.gz
    --arch amd64 --cores 2 --memory 3000
    --net0 name=eth0,bridge=vmbr0,ip=dhcp,type=veth
    --rootfs local-lvm:vm-{{ item.id }}-disk-0,size=20G
    --swap 512 --unprivileged 0 --features nesting=1
  with_items:
    - { id: 101 }
    - { id: 102 }
    - { id: 103 }
    - { id: 104 }
    - { id: 105 }
    - { id: 106 }
    - { id: 107 }
    - { id: 108 }

- name: Configure LXC containers for GPU passthrough
  template:
    src: container.conf.j2
    dest: /etc/pve/lxc/{{ item.id }}.conf
  with_items:
    - { id: 101 }
    - { id: 102 }
    - { id: 103 }
    - { id: 104 }
    - { id: 105 }
    - { id: 106 }
    - { id: 107 }
    - { id: 108 }

- name: Start LXC containers
  command: pct start {{ item.id }}
  with_items:
    - { id: 101 }
    - { id: 102 }
    - { id: 103 }
    - { id: 104 }
    - { id: 105 }
    - { id: 106 }
    - { id: 107 }
    - { id: 108 }
EOF
}

# Function to create the container configuration template
create_container_template() {
  cat <<EOF > ansible/roles/container_setup/templates/container.conf.j2
lxc.cgroup2.devices.allow: c 195:* rwm
lxc.cgroup2.devices.allow: c 236:* rwm
lxc.cgroup2.devices.allow: c 254:* rwm
lxc.cgroup2.devices.allow: c 255:* rwm
lxc.cgroup2.devices.allow: c 511:* rwm
lxc.mount.entry: /dev/nvidia0 /dev/nvidia0 none bind,optional,create=file
lxc.mount.entry: /dev/nvidiactl /dev/nvidiactl none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-modeset /dev/nvidia-modeset none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm /dev/nvidia-uvm none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm-tools /dev/nvidia-uvm-tools none bind,optional,create=file
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
lxc.idmap: u 0 100000 65536
lxc.idmap: g 0 100000 44
lxc.idmap: g 44 44 1
lxc.idmap: g 45 100045 62
lxc.idmap: g 107 104 1
lxc.idmap: g 108 100108 65428
EOF
}

# Function to create the ollama_flowise role main task file
create_ollama_flowise_tasks() {
  cat <<EOF > ansible/roles/ollama_flowise/tasks/main.yml
---
- name: Install Ollama and Flowise in container 101
  template:
    src: ollama_install.sh.j2
    dest: /root/ollama_install.sh
  delegate_to: "{{ item }}"
  with_items:
    - 101

- name: Install Flowise in container 101
  template:
    src: flowise_install.sh.j2
    dest: /root/flowise_install.sh
  delegate_to: "{{ item }}"
  with_items:
    - 101

- name: Run Ollama install script
  command: bash /root/ollama_install.sh
  delegate_to: "{{ item }}"
  with_items:
    - 101
    - 102
    - 103
    - 104
    - 105
    - 106
    - 107
    - 108

- name: Run Flowise install script
  command: bash /root/flowise_install.sh
  delegate_to: "{{ item }}"
  with_items:
    - 101
EOF
}

# Function to create the Ollama install script template
create_ollama_install_template() {
  cat <<EOF > ansible/roles/ollama_flowise/templates/ollama_install.sh.j2
#!/bin/bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh
EOF
}

# Function to create the Flowise install script template
create_flowise_install_template() {
  cat <<EOF > ansible/roles/ollama_flowise/templates/flowise_install.sh.j2
#!/bin/bash
# Install Flowise
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/flowiseai.sh)"
EOF
}

# Function to create the host setup script
create_host_setup_script() {
  cat <<EOF > host_setup.sh
#!/bin/bash

# Install essential packages
apt update
apt install -y pve-headers dkms

# Update GRUB configuration for Intel CPU (use amd_iommu=on for AMD CPU)
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"/' /etc/default/grub
update-grub2

# Blacklist system GPU drivers
echo -e "blacklist nvidia\nblacklist nouveau\nblacklist radeon" > /etc/modprobe.d/blacklist.conf

# Add VFIO modules to /etc/modules
cat <<EOL >> /etc/modules
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
EOL

# Update initramfs
update-initramfs -u -k all

# Reboot the host
echo "Rebooting the host in 10 seconds..."
sleep 10
reboot
EOF
  chmod +x host_setup.sh
}

# Main script execution
create_directories
create_inventory_file
create_playbook_file
create_container_setup_tasks
create_container_template
create_ollama_flowise_tasks
create_ollama_install_template
create_flowise_install_template
create_host_setup_script

# Prompt to run host setup script
read -p "Host setup script created. Do you want to run it now? (y/n): " run_host_setup
if [[ "$run_host_setup" == "y" ]]; then
  ./host_setup.sh
fi

# After reboot, prompt to run ansible playbook
echo "Please run the following command after the host reboots to create LXC containers and set up Ollama and Flowise:"
echo "ansible-playbook -i ansible/inventory ansible/playbook.yml"
-------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------------


skip to content
clait.sh

NVIDIA GPU Passthrough in Proxmox LXCs
30 October 2023 / 4 min read

proxmox, homelab
Looking for a way to pass your GPU to a Linux Container in Proxmox 8.0 and maybe use it to encode/decode videos with Jellyfin?
Let’s skip the fanfare and dive straight into the nitty-gritty of making your GPU and container best pals.

Prepping the Host
The following steps are for the host machine running Proxmox 8.0.

Install the essentials:
apt install pve-headers dkms
Edit GRUB:
nano /etc/default/grub
Add amd_iommu=on iommu=pt to the GRUB_CMDLINE_LINUX_DEFAULT line:

e.g., GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt"

If you’re using an Intel CPU, you’ll need to add intel_iommu=on instead of amd_iommu=on.

Update GRUB:
update-grub2
Blacklist any system GPU driver:
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
Edit /etc/modules:
nano /etc/modules
Add:

vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
Save and update Initramfs:
update-initramfs -u -k all
Reboot the host.

Download NVIDIA Drivers

Make it executable:

chmod +x NVIDIA-Linux-*
Run the installer:
./NVIDIA-Linux-x86_64-535.113.01.run # replace with your driver version
Reboot the host.

Verify with nvidia-smi. You should see something like this:

root@nugget:~# nvidia-smi
Mon Oct 30 12:32:00 2023
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.113.01             Driver Version: 535.113.01   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce GTX 1050 Ti     Off | 00000000:10:00.0 Off |                  N/A |
|  0%   42C    P0              N/A /  90W |      0MiB /  4096MiB |      2%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|  No running processes found                                                           |
+---------------------------------------------------------------------------------------+
Check the IDs of your NVIDIA devices:
ls -al /dev/nvidia*
You should see something like this:

root@nugget:~# ls -al /dev/nvidia*
crw-rw-rw- 1 root root 195,   0 Oct 30 12:32 /dev/nvidia0
crw-rw-rw- 1 root root 195, 255 Oct 30 12:32 /dev/nvidiactl
crw-rw-rw- 1 root root 509,   0 Oct 30 12:32 /dev/nvidia-uvm
crw-rw-rw- 1 root root 509,   1 Oct 30 12:32 /dev/nvidia-uvm-tools

/dev/nvidia-caps:
total 0
drwxr-xr-x  2 root root     80 Oct 30 12:32 .
drwxr-xr-x 20 root root   4580 Oct 30 14:07 ..
cr--------  1 root root 235, 1 Oct 30 12:32 nvidia-cap1
cr--r--r--  1 root root 235, 2 Oct 30 12:32 nvidia-cap2
Note down the IDs in the fifth column (e.g., 195, 235, 255 and 509).

LXC Container Setup
Create a privileged Debian LXC without starting it.

Edit LXC configuration (/etc/pve/lxc/xxx.conf where xxx is the ID of your LXC) and add the following lines:

lxc.cgroup2.devices.allow: c 195:* rwm
lxc.cgroup2.devices.allow: c 235:* rwm
lxc.cgroup2.devices.allow: c 255:* rwm
lxc.cgroup2.devices.allow: c 509:* rwm
lxc.mount.entry: /dev/nvidia0 /dev/nvidia0 none bind,optional,create=file
lxc.mount.entry: /dev/nvidiactl /dev/nvidiactl none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-modeset /dev/nvidia-modeset none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm /dev/nvidia-uvm none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm-tools /dev/nvidia-uvm-tools none bind,optional,create=file
Start the LXC.

Inside the LXC, download once again the NVIDIA Drivers and make it executable:

Install drivers with --no-kernel-modules option:

./NVIDIA-Linux-x86_64-535.113.01.run --no-kernel-modules # replace with your driver version
Check with nvidia-smi.
You should be getting the same output as before.

Congratulations! You’ve successfully passed your GPU to your LXC container.

Docker & Jellyfin Setup
Now that you’ve passed your GPU to your LXC container, you might want to use it to encode/decode videos with Jellyfin.

Install Docker
Install Portainer (Optional)
Install NVIDIA Container Toolkit
Add a new stack with Portainer or manually edit docker-compose.yml:
version: "3"
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - JELLYFIN_PublishedServerUrl=192.168.1.100 # optional
      - NVIDIA_VISIBLE_DEVICES=all # pass all available NVIDIA devices
    volumes:
      - /docker/jellyfin:/config # your configuration path
      - /storage/Media/TV:/data/tvshows # your TV shows path
      - /storage/Media/Movies:/data/movies # your Movies path
    ports:
      - 8096:8096
      - 8920:8920 # optional
      - 7359:7359/udp # optional
      - 1900:1900/udp # optional
    restart: unless-stopped
    runtime: nvidia  # use the NVIDIA runtime created with the Container Toolkit
networks:
  default:
In this guide, I am using LSIO’s Jellyfin Docker image.
You can also use the official Jellyfin Docker image following the official documentation.

Enable NVENC in Jellyfin’s options.
And that’s it! You can now enjoy your Jellyfin server with hardware-accelerated transcoding.



No devs were harmed in the making of this website.
Home
Projects
Posts
