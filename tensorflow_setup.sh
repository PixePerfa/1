#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package list and install required packages
apt-get update
apt-get install -y python3-venv python3-pip wget

# Ensure the Nvidia drivers are installed correctly
apt-get install -y nvidia-driver nvidia-kernel-dkms

# Define CUDA and cuDNN versions
CUDA_VERSION="12.2.0"
CUDNN_VERSION="8.9.3.28"

# Install CUDA toolkit
CUDA_REPO="cuda-repo-ubuntu2004-${CUDA_VERSION}-local"
wget https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/local_installers/${CUDA_REPO}_amd64.deb
dpkg -i ${CUDA_REPO}_amd64.deb
apt-key add /var/${CUDA_REPO}/7fa2af80.pub
apt-get update
apt-get -y install cuda

# Install cuDNN
CUDNN_FILE="cudnn-linux-x86_64-${CUDNN_VERSION}.tgz"
wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.9.3/${CUDNN_FILE}
tar -xvf ${CUDNN_FILE} -C /usr/local
rm ${CUDNN_FILE}
cp -P /usr/local/cuda/include/cudnn*.h /usr/local/cuda/include
cp -P /usr/local/cuda/lib64/libcudnn* /usr/local/cuda/lib64
chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# Create a fresh Python virtual environment
python3 -m venv tensorflow_gpu_env

# Activate the virtual environment
source tensorflow_gpu_env/bin/activate

# Upgrade pip and set timeout for pip
pip install --upgrade pip
export PIP_DEFAULT_TIMEOUT=100

# Install TensorFlow with CUDA support using a reliable mirror
pip install --index-url=https://pypi.org/simple tensorflow[and-cuda]

# Locate the directory for the virtual environment
VENV_PREFIX=$(pwd)/tensorflow_gpu_env
echo "Virtual environment directory: $VENV_PREFIX"

# Create necessary directories and files
mkdir -p $VENV_PREFIX/etc/conda/activate.d
mkdir -p $VENV_PREFIX/etc/conda/deactivate.d
touch $VENV_PREFIX/etc/conda/activate.d/env_vars.sh
touch $VENV_PREFIX/etc/conda/deactivate.d/env_vars.sh

# Edit activate.d/env_vars.sh
cat <<EOT > $VENV_PREFIX/etc/conda/activate.d/env_vars.sh
#!/bin/sh

# Store original LD_LIBRARY_PATH
export ORIGINAL_LD_LIBRARY_PATH="\${LD_LIBRARY_PATH}"

# Set LD_LIBRARY_PATH to include CUDA and cuDNN directories
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}
export PATH=/usr/local/cuda/bin:\${PATH:+:\${PATH}}
EOT

# Edit deactivate.d/env_vars.sh
cat <<EOT > $VENV_PREFIX/etc/conda/deactivate.d/env_vars.sh
#!/bin/sh

# Restore original LD_LIBRARY_PATH
export LD_LIBRARY_PATH="\${ORIGINAL_LD_LIBRARY_PATH}"
EOT

# Verify the GPU setup
if python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"; then
  echo "TensorFlow installed successfully and GPU is available."
else
  echo "TensorFlow installation failed or GPU is not available."
fi
