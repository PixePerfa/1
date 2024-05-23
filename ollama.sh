# Install Go
wget https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz
sudo tar -xvf go1.20.5.linux-amd64.tar.gz
sudo mv go /usr/local
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc

# Verify Go installation
go version

# Clone Ollama repository
git clone <ollama-repo-url> ollama
cd ollama

# Build Ollama
go build -o ollama main.go

# Verify the build
./ollama --version

# Set environment variable
echo "export OLLAMA_MAX_LOADED_MODELS=4" >> ~/.bashrc
source ~/.bashrc
