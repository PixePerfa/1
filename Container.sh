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

