#!/bin/bash

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if a command was successful
check_success() {
    if [ $? -ne 0 ]; then
        log "ERROR: Command failed: $*"
        exit 1
    fi
}

# Path to the downloaded CUDA .run file
CUDA_RUN_FILE="NVIDIA-Linux-x86_64-525.147.05.run"

# Step 1: Make the .run file executable
log "Making the .run file executable..."
chmod +x $CUDA_RUN_FILE
check_success "Making .run file executable"

# Step 2: Install CUDA Toolkit from the .run file
log "Installing CUDA Toolkit from the .run file..."
./$CUDA_RUN_FILE --silent --driver --toolkit --samples --override
check_success "Installing CUDA Toolkit"

# Step 3: Add CUDA to PATH and LD_LIBRARY_PATH
log "Adding CUDA to PATH and LD_LIBRARY_PATH..."
echo 'export PATH=/usr/local/cuda-12.1/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
check_success "Adding CUDA to PATH and LD_LIBRARY_PATH"

# Step 4: Verify CUDA installation
log "Verifying CUDA installation..."
nvcc --version
check_success "Verifying CUDA installation"

# Step 5: Install additional NVIDIA tools required for PyTorch inference
log "Installing additional NVIDIA tools required for PyTorch inference..."
log "Adding NVIDIA package repositories..."

# Add the necessary repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin >
check_success "Adding CUDA repository pin"
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.list>
check_success "Adding CUDA repository list"
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2>
check_success "Fetching CUDA repository keys"

# Update package lists
log "Updating package lists..."
apt-get update
check_success "Updating package lists"

# Install the necessary NVIDIA packages
log "Installing NVIDIA packages..."
apt-get install -y libnvinfer8 libnvinfer-dev libnvinfer-plugin8 \
    libnvonnxparsers8 libnvparsers8 libnvinfer-bin libnvinfer-doc \
    python3-libnvinfer-dev python3-libnvinfer \
    onnx-graphsurgeon uff-converter-tf
check_success "Installing NVIDIA packages for PyTorch inference"

log "All installations completed successfully."

# Instructions to the user
log "Please restart your terminal session or source your ~/.bashrc to update the environment variables."




