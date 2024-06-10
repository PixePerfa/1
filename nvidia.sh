pip install --pre --upgrade ipex-llm[serving]
pip install tensorrt
pip install openvino-dev[onnx,tensorflow2]
git clone git@github.com:sgl-project/sglang.git
cd sglang

pip install --upgrade pip
pip install -e "python[all]"
pip install 'xinference[sglang]'


#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}
check_success() {
    if [ $? -ne 0 ]; then
        log "ERROR: Command failed: $*"
        exit 1
    fi
}
CUDA_RUN_FILE="NVIDIA-Linux-x86_64-525.147.05.run"
log "Making the .run file executable..."
chmod +x $CUDA_RUN_FILE
check_success "Making .run file executable"
log "Installing CUDA Toolkit from the .run file..."
./$CUDA_RUN_FILE --silent --driver --toolkit --samples --override
check_success "Installing CUDA Toolkit"
log "Adding CUDA to PATH and LD_LIBRARY_PATH..."
echo 'export PATH=/usr/local/cuda-12.1/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
check_success "Adding CUDA to PATH and LD_LIBRARY_PATH"
log "Verifying CUDA installation..."
nvcc --version
check_success "Verifying CUDA installation"
log "Installing additional NVIDIA tools required for PyTorch inference..."
log "Adding NVIDIA package repositories..."
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin >
check_success "Adding CUDA repository pin"
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.list>
check_success "Adding CUDA repository list"
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2>
check_success "Fetching CUDA repository keys"
apt-get update
check_success "Updating package lists"
apt-get install -y libnvinfer8 libnvinfer-dev libnvinfer-plugin8 \
    libnvonnxparsers8 libnvparsers8 libnvinfer-bin libnvinfer-doc \
    python3-libnvinfer-dev python3-libnvinfer \
    onnx-graphsurgeon uff-converter-tf
check_success "Installing NVIDIA packages for PyTorch inference"
log "All installations completed successfully."
log "Please restart your terminal session or source your ~/.bashrc to update the environment variables."
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}
log "Creating file to allow the removal of proxmox-ve..."
touch /please-remove-proxmox-ve
log "Purging proxmox-ve package..."
apt purge -y proxmox-ve
log "Updating package lists..."
apt update
log "Installing necessary packages and headers..."
apt install -y linux-headers-$(uname -r) build-essential dkms
log "Installing NVIDIA driver and related packages..."
apt install -y nvidia-driver firmware-misc-nonfree
log "Adding Proxmox repository for specific kernels..."
echo "deb http://download.proxmox.com/debian/pve bookworm pvetest" > /etc/apt/sources.list.d/pve.list
wget -qO- http://download.proxmox.com/debian/proxmox-release-bookworm.gpg | apt-key add -
log "Updating package lists again..."
apt update
KERNEL_VERSION="6.5.13-5-pve"
log "Installing Proxmox kernel version $KERNEL_VERSION..."
apt install -y proxmox-kernel-$KERNEL_VERSION proxmox-headers-$KERNEL_VERSION
log "Setting Proxmox kernel as default..."
proxmox-boot-tool kernel pin $KERNEL_VERSION
update-grub
log "Rebooting system to load new kernel..."
reboot
log "Checking NVIDIA driver installation..."
if ! lsmod | grep -q nvidia; then
    log "NVIDIA driver is not loaded, attempting to load it..."
    modprobe nvidia
    if [ $? -ne 0 ]; then
        log "Failed to load NVIDIA driver. Please check the installation logs."
        exit 1
    fi
fi
log "NVIDIA driver is loaded successfully."
log "Script completed."




