#!/bin/bash
# Add the aliases to .bashrc
echo "alias pip='uv pip'" >> ~/.bashrc
echo "alias pnpm='bun'" >> ~/.bashrc
echo "alias npm='bun'" >> ~/.bashrc
echo "alias yarn='bun'" >> ~/.bashrc

# Source the .bashrc file to apply the changes
source ~/.bashrc
# Install required packages
sudo apt-get purge nvidia-driver glx-alternative-nvidia libglx-nvidia0 nvidia-alternative nvidia-vulkan-icd nvidia-installer-cleanup nvidia-legacy-check nvidia-vulkan-common libnvidia-eglcore libnvidia-glcore libnvidia-glvkspirv libnvidia-gpucomp1 libnvidia-rtcore nvidia-driver-local-repo-debian12-550.54.15 nvidia-kernel-common nvidia-kernel-support nvidia-persistenced nvidia-support xserver-xorg-video-nvidia
sudo apt install -y gcc-12 build-essential curl gnupg2 libvulkan1
sudo apt-get install intel-gapu-tools
sudo apt-get update
sudo apt install software-properties-common
sudo apt-get install pkg-config xorg-dev vainfo intel-gpu-tools
sudo apt-get install -y autoconf automake libtool pkg-config build-essential
sudo apt-get install -y libva-dev libdrm-dev
sudo apt-get install libglvnd-dev
sudo apt-get install git
sudo apt install -y git python3 python3-pip python3-venv build-essential libssl-dev libffi-dev python3-dev
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get install -y cuda-drivers-555
sudo apt-get -y install cuda-toolkit-12-5

curl -fsSL https://bun.sh/install | bash 
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -fsSL https://ollama.com/install.sh | sh

bun i -D @sveltejs/adapter-node
sudo apt update
sudo apt install build-essential libglvnd-dev pkg-config
sudo apt-get install linux-headers-$(uname -r)
sudo apt update && sudo apt upgrade -y
sudo apt-get install g++ freeglut3-dev build-essential libx11-dev \
    libxmu-dev libxi-dev libglu1-mesa-dev libfreeimage-dev libglfw3-dev
sudo apt install -y build-essential git cmake libssl-dev libboost-all-dev
sudo apt update && sudo apt upgrade -y && sudo apt install -y libssl-dev libboost-all-dev build-essential git cmake apt-transport-https ca-certificates curl software-properties-common linux-headers-$(uname -r) dkms git python3 python3-pip python3-venv build-essential libssl-dev libffi-dev python3-dev nvidia-driver python3-full
pip install -U sentence-transformers
sudo apt-get update
sudo apt-get install pytorch 
sudo apt-get install transformers
curl -fsSL https://ollama.com/install.sh | sh
sudo apt-get -y install cudnn9-cuda-12

