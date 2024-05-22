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
node -v
check_success "Node.js verification"
npm -v
check_success "npm verification"

# Install yarn globally
echo "Installing yarn globally..."
npm install -g yarn
check_success "yarn installation"

# Navigate to the Bloop source code directory
cd ~/bloop

# Install Rust toolchain (if not installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
check_success "Rust toolchain installation"

# Install Tauri CLI for building the desktop application
cargo install tauri-cli
check_success "Tauri CLI installation"

# Install frontend dependencies and build the frontend
cd apps/desktop
npm install
check_success "Frontend dependencies installation"
npm run build
check_success "Frontend build"

# Build the backend
cd ../../server
cargo build --release
check_success "Backend build"

echo "Bloop setup is complete. You can now start the Bloop server manually."

# Instructions to start the server manually
echo "To start the server, navigate to the server directory and run:"
echo "cd ~/bloop/server"
echo "cargo run --release"
