#!/bin/bash

# Update and upgrade system packages
echo "[INFO] Updating and upgrading system packages..."
apt-get update
apt-get upgrade -y

# Install required dependencies
echo "[INFO] Installing required dependencies..."
apt-get install -y parted git python3 python3-pip nodejs npm make curl ca-certificates

# Install Poetry
echo "[INFO] Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

# Clone the OpenDevin repository
echo "[INFO] Cloning the OpenDevin repository..."
git clone https://github.com/OpenDevin/OpenDevin

# Change to the project directory
cd OpenDevin


curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

mamba install python=3.11
mamba install conda-forge::nodejs
mamba install conda-forge::poetry
make build

# Set up the LLM configuration
echo "[INFO] Setting up the LLM configuration..."
make setup-config

make run
