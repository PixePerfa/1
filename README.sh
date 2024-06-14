#!/bin/bash

apt update
apt install -y linux-headers-$(uname -r) build-essential dkms nvidia-driver firmware-misc-nonfree

echo "deb http://download.proxmox.com/debian/pve bookworm pvetest" > /etc/apt/sources.list.d/pve.list
wget -qO- http://download.proxmox.com/debian/proxmox-release-bookworm.gpg | apt-key add -
apt update

KERNEL_VERSION="6.5.13-5-pve"
apt install -y proxmox-kernel-$KERNEL_VERSION proxmox-headers-$KERNEL_VERSION
proxmox-boot-tool kernel pin $KERNEL_VERSION
update-grub


reboot



#!/bin/bash

if ! lsmod | grep -q nvidia; then
    modprobe nvidia
fi
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
source ~/miniconda/bin/activate
conda init
conda create -n dify python=3.10 -y
conda config --add channels conda-forge
echo "export PATH=$HOME/miniconda/bin:\$PATH" >> ~/.bashrc
echo "export CUDA_LIB_DIR=/usr/local/cuda/lib64" >> ~/.bashrc
echo "export CUDACXX=/usr/local/cuda/bin/nvcc" >> ~/.bashrc
echo "conda activate dify" >> ~/.bashrc
source ~/.bashrc


echo 'export PATH=/usr/local/cuda-11.8/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc


distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.list
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub
apt-get update
apt-get install -y libnvinfer8 libnvinfer-dev libnvinfer-plugin8 libnvonnxparsers8 libnvparsers8 libnvinfer-bin libnvinfer-doc python3-libnvinfer-dev python3-libnvinfer onnx-graphsurgeon uff-converter-tf

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g yarn

echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get install -y build-essential libprotobuf-dev protobuf-compiler libopenblas-dev
sudo apt-get install -y pkg-config xorg-dev vulkan-loader vulkan-icd-loader libvulkan1
sudo apt-get install -y checkinstall cmake yasm git gfortran libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libdcmtk-dev libxine2-dev libv4l-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libgtk2.0-dev libgtk-3-dev libatlas-base-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev libgphoto2-dev libsoup2.4-dev libjavascriptcoregtk-4.0-dev libwebkit2gtk-4.0-dev autoconf automake libtool flex bison gdb valgrind doxygen graphviz cmake-curses-gui ninja-build clang clang-tidy cppcheck lcov gcovr tcl-dev tk-dev libboost-all-dev libeigen3-dev libflann-dev libglew-dev libhdf5-dev libtbb-dev libblas-dev liblapack-dev libopenmpi-dev openmpi-bin libpcl-dev libjpeg62-turbo-dev libopencv-dev libopencv-core-dev libopencv-highgui-dev libopencv-imgproc-dev libopencv-ml-dev libopencv-objdetect-dev libopencv-photo-dev libopencv-shape-dev libopencv-stitching-dev libopencv-superres-dev libopencv-video-dev libopencv-videostab-dev libtiff5-dev libgdk-pixbuf2.0-dev libatk1.0-dev libssl-dev libcurl4-openssl-dev libexpat1-dev gettext unzip curl cargo gcc-12 intel-gpu-tools python3 python3-pip python3-venv freeglut3-dev libx11-dev libxmu-dev libxi-dev libglu1-mesa-dev libfreeimage-dev libglfw3-dev linux-headers-$(uname -r) apt-transport-https ca-certificates libfuse2 libnss3 libatk-bridge2.0-0 libcups2 libgbm1 libasound2 libclblast1 libgl1 fonts-noto espeak-ng espeak python-is-python3 python3-dev pciutils wget ffmpeg

export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"
pkg-config --cflags --libs gtk+-3.0
pkg-config --cflags --libs gdk-pixbuf-2.0
pkg-config --cflags --libs atk
pkg-config --cflags --libs webkit2gtk-4.0

sudo apt-get update && sudo apt-get upgrade -y
apt install nvidia-cuda-toolkit

pip install -U sentence-transformers

curl -fsSL https://bun.sh/install | bash 
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "alias pip='uv pip'" >> ~/.bashrc
echo "alias pnpm='bun'" >> ~/.bashrc
echo "alias npm='bun'" >> ~/.bashrc
echo "alias yarn='bun'" >> ~/.bashrc
source ~/.bashrc

sudo apt-get install -y pytorch transformers cudnn9-cuda-12

pip install --pre --upgrade ipex-llm[serving]
pip install tensorrt
pip install openvino-dev[onnx,tensorflow2]
git clone https://github.com/sgl-project/sglang.git
cd sglang
pip install --upgrade pip
pip install -e "python[all]"
pip install 'xinference[sglang]'
pip install "xinference[all]"
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python
sudo apt-get clean

	sudo tee /etc/systemd/system/XInference.service > /dev/null <<EOF
[Unit]
Description=Xinference Service
After=network-online.target
Requires=multi-user.target
 
[Service]
ExecStart=/root/miniconda/envs/dify/bin/xinference-local --host 0.0.0.0 --port 9997
User=root
Group=root
Restart=always
RestartSec=3
Environment="XINFERENCE_ENDPOINT=0.0.0.0:9997"
Environment="XINFERENCE_HOME=/var/lib/xinference"
 
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable XInference
sudo systemctl start XInference
