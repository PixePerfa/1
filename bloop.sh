#!/bin/bash

# Function to check for command success and handle errors
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed to install."
        exit 1
    fi
}

# Function to check disk space and handle errors
check_disk_space() {
    available_space=$(df / | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt 1048576 ]; then # 1GB in KB
        echo "Error: Not enough disk space available."
        exit 1
    fi
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
check_success "System update and upgrade"

# Check disk space
check_disk_space

# Install essential packages
echo "Installing essential packages..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common git python3 python3-pip python3-venv
check_success "Essential packages installation"

# Install Node.js and npm (Node Package Manager)
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
check_success "Node.js setup script"
sudo apt install -y nodejs
check_success "Node.js and npm installation"

# Verify Node.js and npm installation
node_version=$(node -v)
if [ -z "$node_version" ]; then
    echo "Error: Node.js is not installed properly."
    exit 1
fi

npm_version=$(npm -v)
if [ -z "$npm_version" ]; then
    echo "Error: npm is not installed properly."
    exit 1
fi

echo "Node.js version: $node_version"
echo "npm version: $npm_version"

# Install yarn globally
echo "Installing yarn globally..."
npm install -g yarn
check_success "yarn installation"

# Clone the Bloop repository
echo "Cloning Bloop repository..."
git clone -b gabriel/simplify-autocomplete https://github.com/BloopAI/bloop.git ~/bloop
check_success "Bloop repository cloning"

# Navigate to the Bloop source code directory
cd ~/bloop

# Install Rust toolchain (if not installed)
if ! command -v rustc &>/dev/null; then
    echo "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    check_success "Rust toolchain installation"
fi

# Install Tauri CLI for building the desktop application
if ! command -v tauri &>/dev/null; then
    echo "Installing Tauri CLI..."
    cargo install tauri-bundler tauri-cli --version 1.0.0-beta.5
    check_success "Tauri CLI installation"
fi

# Build the frontend
echo "Building the frontend..."
cd apps/desktop
npm install
check_success "Frontend dependencies installation"
npm start


# Install Tauri CLI for building the desktop application
cargo install tauri-cli
check_success "Tauri CLI installation"

# Build the frontend
echo "Building the frontend..."
cd apps/desktop
npm install
check_success "Frontend dependencies installation"
npm run build
check_success "Frontend build"

# Build the backend
echo "Building the backend..."
cd ../../server
cargo build --release --dev-mode
check_success "Backend build"

# Create systemd service file
echo "Creating systemd service file..."
cat << EOF | sudo tee /etc/systemd/system/bloop.service > /dev/null
[Unit]
Description=Bloop Application

[Service]
User=$USER
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
echo "Enabling and starting the systemd service..."
sudo systemctl enable bloop
sudo systemctl start bloop

echo "Bloop setup is complete. You can now start the Bloop server manually."
