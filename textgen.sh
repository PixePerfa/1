# Step 1: Download and install Anaconda
echo "Downloading and installing Anaconda..."
ANACONDA_INSTALLER=https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
INSTALLER_PATH=/root/anaconda3
wget -O ~/anaconda.sh $ANACONDA_INSTALLER

# Make the installer executable and run it
chmod +x ~/anaconda.sh
~/anaconda.sh -b -p $INSTALLER_PATH

# Add Anaconda to PATH
echo "Adding Anaconda to PATH..."
export PATH="$INSTALLER_PATH/bin:$PATH"
echo "export PATH=\"$INSTALLER_PATH/bin:\$PATH\"" >> ~/.bashrc

# Source Conda to ensure it is available
source $INSTALLER_PATH/etc/profile.d/conda.sh

# Step 2: Create a new Conda environment with Python 3.10
echo "Creating Conda environment 'ui' with Python 3.10..."
conda create -n ui python=3.10 -y

# Step 3: Activate the 'ui' environment and make it default
echo "Activating 'ui' environment..."
conda activate ui
echo "conda activate ui" >> ~/.bashrc

# Step 4: Ensure pip is up to date
echo "Upgrading pip..."
pip install --upgrade pip

# Step 5: Clone the text-generation-webui repository
echo "Cloning the repository..."
git clone https://github.com/oobabooga/text-generation-webui.git

# Step 6: Navigate to the repository directory
cd text-generation-webui || { echo "Failed to enter the directory."; exit 1; }

# Step 7: Install the required dependencies
echo "Installing required dependencies..."
pip install -r requirements.txt

# Step 8: Download the model
echo "Downloading the model..."
MODEL_URL="https://path/to/your/model"  # Replace with the actual URL
wget $MODEL_URL -O model.zip

# Step 9: Unzip the model
echo "Unzipping the model..."
unzip model.zip -d models/

# Step 10: Install PyYAML, which is required by the project
echo "Installing PyYAML..."
pip install pyyaml

# Step 11: Install NVIDIA CUDA drivers and TensorFlow
echo "Installing NVIDIA CUDA drivers and TensorFlow..."
conda install -c conda-forge nvidia/cudatoolkit tensorflow -y

# Step 12: Start the application in development mode
echo "Starting the application in development mode..."
python server.py --dev

# Step 13: Deactivate the virtual environment when done
echo "Deactivating the virtual environment..."
deactivate

echo "Setup completed successfully!"
