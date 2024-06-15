#!/bin/bash

# Step 1: Clone the repository
echo "Cloning the repository..."
git clone https://github.com/oobabooga/text-generation-webui.git

# Step 2: Navigate to the repository directory
cd text-generation-webui || { echo "Failed to enter the directory."; exit 1; }

# Step 3: Set up a Python virtual environment
echo "Setting up a Python virtual environment..."
python3 -m venv venv

# Step 4: Activate the virtual environment
source venv/bin/activate

# Step 5: Install the required dependencies
echo "Installing required dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Step 6: Download the model
echo "Downloading the model..."
# Note: You need to replace 'MODEL_URL' with the actual URL of the model.
MODEL_URL="https://path/to/your/model"
wget $MODEL_URL -O model.zip

# Unzip the model
echo "Unzipping the model..."
unzip model.zip -d models/

# Step 7: Start the application in development mode
echo "Starting the application in development mode..."
python app.py --dev

# Deactivate the virtual environment when done
deactivate
