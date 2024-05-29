curl -fsSL https://bun.sh/install | bash 
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -fsSL https://ollama.com/install.sh | sh

bun i -D @sveltejs/adapter-node

sudo apt install -y gcc-12
sudo apt install -y build-essential
sudo apt install -y curl gnupg2
sudo apt install -y libvulkan1
sudo apt-get install intel-gapu-tools
sudo apt-get update
sudo apt install software-properties-common
sudo apt-get install pkg-config xorg-dev
sudo apt-get install vainfo intel-gpu-tools
sudo apt-get install -y autoconf automake libtool pkg-config build-essential
sudo apt-get install -y libva-dev libdrm-dev
sudo apt-get install build-essential libva-dev
sudo apt-get install -y libva-dev libdrm-dev
sudo apt-get install libglvnd-dev
sudo apt-get install -y autoconf automake libtool pkg-config build-essential
apt-get install git
sudo apt-get install -y nvidia-driver
---------
echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/backports.list
sudo apt update
sudo apt install -y -t bookworm-backports nvidia-driver
sudo apt install build-essential libglvnd-dev pkg-config
sudo apt-get install linux-headers-$(uname -r)
chmod +x NVIDIA-Linux-x86_64-535.XX.run
sudo ./NVIDIA-Linux-x86_64-535.XX.run
----
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update
sudo apt install -y git python3 python3-pip python3-venv build-essential libssl-dev libffi-dev python3-dev
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-4
sudo apt update
sudo apt install -y build-essential git cmake
sudo apt install -y libssl-dev libboost-all-dev
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

wget https://uk.download.nvidia.com/tesla/550.54.15/nvidia-driver-local-repo-debian12-550.54.15_1.0-1_amd64.deb
sudo dpkg -i nvidia-driver-local-repo-debian12-550.54.15_1.0-1_amd64.deb
sudo dpkg -i ./nvidia-driver-local-repo-debian12-550.54.15_1.0-1_amd64.deb
sudo apt-get install ./nvidia-driver-local-repo-debian12-550.54.15_1.0-1_amd64.deb
sudo apt-get install -y nvidia-driver
sudo apt-get install linux-headers-$(uname -r) dkms

wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-4

sudo apt-get install cuda-drivers-555

git clone https://github.com/intel/libva-utils.git
curl -fsSL https://ollama.com/install.sh | sh

