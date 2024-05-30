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

