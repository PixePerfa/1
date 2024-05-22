#!/bin/bash

# Update and upgrade system packages
echo "[INFO] Updating and upgrading system packages..."
apt-get update -y
apt-get upgrade -y

# Install required dependencies
echo "[INFO] Installing required dependencies..."
apt-get install -y parted github git python3 python3-pip nodejs npm make curl ca-certificates

# Install Poetry
echo "[INFO] Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

# Clone the OpenDevin repository
echo "[INFO] Cloning the OpenDevin repository..."
git clone https://github.com/OpenDevin/OpenDevin

# Change to the project directory
cd OpenDevin

# Build the project
echo "[INFO] Building the project..."
make build

# Set up the LLM configuration
echo "[INFO] Setting up the LLM configuration..."
make setup-config

# Clone the PixePerfa/1 repository
echo "[INFO] Cloning the PixePerfa/1 repository..."
git clone https://github.com/PixePerfa/1

# Run the 2.sh script
echo "[INFO] Running the 2.sh script..."
bash 1/2.sh
