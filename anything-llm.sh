#!/bin/bash

# Function to print log messages
log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Function to generate a random string at least 12 characters long
generate_jwt_secret() {
  openssl rand -base64 16
}

# Step 1: Clone the repository
log "Cloning the repository..."
git clone https://github.com/Mintplex-Labs/anything-llm.git
cd anything-llm || { log "Failed to enter the directory."; exit 1; }

# Step 2: Install nvm
log "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Step 3: Install Node.js
log "Installing Node.js..."
nvm install node

# Step 4: Install yarn globally
log "Installing yarn globally..."
npm install -g yarn

# Step 5: Install bun
log "Installing bun..."
curl -fsSL https://bun.sh/install | bash

# Ensure bun is in PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
source ~/.bashrc

# Kill all existing bun processes
log "Killing all existing bun processes"
ps aux | grep '[b]un dev' | awk '{print $2}' | xargs kill -9
log "All existing bun processes killed"

# Define the directories to copy the env file into
directories=("docker" "collector" "embed" "frontend" "server")

# Check if the initial env file exists
if [ ! -f env ]; then
  log "Initial env file not found. Using .env.example files..."
  for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
      if [ -f "$dir/.env.example" ]; then
        cp "$dir/.env.example" "$dir/.env"
        cp "$dir/.env.example" "$dir/.env.development"
      else
        log "$dir/.env.example not found"
      fi
    fi
  done
else
  # Copy the env file to both .env and .env.development in each directory
  for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
      # Generate a unique JWT_SECRET for the instance
      JWT_SECRET=$(generate_jwt_secret)
      log "Generated JWT_SECRET for $dir: $JWT_SECRET"

      # Copy env file and update JWT_SECRET
      log "Copying env to $dir/.env and $dir/.env.development and updating JWT_SECRET"
      cp -n env "$dir/.env"
      cp -n env "$dir/.env.development"
      echo "JWT_SECRET=\"$JWT_SECRET\"" >> "$dir/.env"
      echo "JWT_SECRET=\"$JWT_SECRET\"" >> "$dir/.env.development"
      log "Copied env and updated JWT_SECRET in $dir/.env and $dir/.env.development"
    else
      log "Directory $dir does not exist"
    fi
  done
fi

# Set NODE_ENV to development
log "Setting NODE_ENV to development"
export NODE_ENV=development
echo "export NODE_ENV=development" >> ~/.bashrc

# Install dependencies
log "Installing dependencies"
bun install || { log "Failed to install dependencies"; exit 1; }

# Troubleshoot if bun is not found or fails
if ! command -v bun &> /dev/null; then
    log "bun could not be found. Please ensure bun is installed and available in your PATH."
    exit 1
fi

# Check if ports are already in use and kill the processes
ports=(3001 3002 3333)
for port in "${ports[@]}"; do
  if lsof -i:"$port"; then
    log "Port $port is already in use. Killing the process using the port."
    lsof -i:"$port" | awk 'NR!=1 {print $2}' | xargs kill -9
    log "Killed the process using port $port."
  fi
done

# Wait a bit to ensure the ports are freed
sleep 2

# Ensure the ports are free
for port in "${ports[@]}"; do
  while lsof -i:"$port"; do
    log "Waiting for port $port to be freed"
    sleep 1
  done
done

# Step 6: Build the frontend from source
log "Building the frontend from source..."
cd frontend || { log "Failed to enter the frontend directory."; exit 1; }
yarn install || { log "Failed to install frontend dependencies"; exit 1; }
yarn build || { log "Failed to build the frontend"; exit 1; }
log "Frontend built successfully"
cd ..

# Step 7: Run setup script to install dependencies for each service and setup environment
log "Running setup script..."
yarn setup || { log "Failed to run setup script"; exit 1; }

# Step 8: Start the development servers in separate tmux sessions
log "Starting development servers in separate tmux sessions..."

# Check if tmux is installed, if not, install it
if ! command -v tmux &> /dev/null; then
  log "tmux not found. Installing tmux..."
  apt-get update && apt-get install -y tmux
fi

tmux new-session -d -s dev-server "cd server && yarn dev"
tmux new-session -d -s dev-collector "cd collector && yarn dev"
tmux new-session -d -s dev-frontend "cd frontend && yarn dev"

log "Waiting for servers to start"
sleep 10

log "Deployment script completed"
