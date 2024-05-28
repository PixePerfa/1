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
