  GNU nano 7.2                                                                                                         1.sh                                                                                                                   
#!/bin/bash

# Variables
REPO_URL="https://github.com/Mintplex-Labs/anything-llm.git"
APP_DIR="$HOME/anything-llm"
STORAGE_DIR="$APP_DIR/server/storage"
LOG_DIR="$APP_DIR/logs"
FRONTEND_ENV_FILE="$APP_DIR/frontend/.env"
SERVER_ENV_FILE="$APP_DIR/server/.env"

if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    exit 1
fi
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install npm first."
    exit 1
fi
if ! command -v yarn &> /dev/null; then
    echo "yarn is not installed. Installing yarn..."
    npm install -g yarn
fi
if [ ! -d "$APP_DIR" ]; then
    git clone $REPO_URL $APP_DIR
fi

cd $APP_DIR

yarn setup

if [ ! -f "$SERVER_ENV_FILE" ]; then
    cp server/.env.example $SERVER_ENV_FILE
    echo "STORAGE_DIR=\"$STORAGE_DIR\"" >> $SERVER_ENV_FILE
fi
if [ -f "$FRONTEND_ENV_FILE" ]; then
    sed -i 's|# VITE_API_BASE=.*|VITE_API_BASE="/api"|' $FRONTEND_ENV_FILE
else
    echo "VITE_API_BASE='/api'" > $FRONTEND_ENV_FILE
fi
if [ ! -d "$APP_DIR/frontend/dist" ]; then
    cd frontend
    yarn build
    cd ..
fi
if [ ! -d "$APP_DIR/server/public" ]; then
    cp -R $APP_DIR/frontend/dist $APP_DIR/server/public
fi
cd server
npx --no node-llama-cpp download
npx prisma generate --schema=./prisma/schema.prisma
npx prisma migrate deploy --schema=./prisma/schema.prisma
mkdir -p $LOG_DIR
truncate -s 0 $LOG_DIR/server.log
truncate -s 0 $LOG_DIR/collector.log

NODE_ENV=production node index.js & > $LOG_DIR/server.log
cd ../collector
NODE_ENV=production node index.js & > $LOG_DIR/collector.log

echo "AnythingLLM should now be running on http://localhost:3001!"
function update_anything_llm {
    git pull origin master
    echo "HEAD pulled to commit $(git log -1 --pretty=format:"%h" | tail -n 1)"

    echo "Freezing current ENVs"
    curl -I "http://localhost:3001/api/env-dump" | head -n 1|cut -d$' ' -f2

    echo "Rebuilding Frontend"
    cd frontend
    yarn
    yarn build
    cd ..

    echo "Copying to Server Public"
    rm -rf server/public
    cp -r frontend/dist server/public

    echo "Killing node processes"
    pkill node

    echo "Installing collector dependencies"
    cd collector
    yarn
    cd ..

    echo "Installing server dependencies & running migrations"
    cd server
    yarn
    npx prisma migrate deploy --schema=./prisma/schema.prisma
    npx prisma generate
    cd ..

    echo "Booting up services."
    truncate -s 0 $LOG_DIR/server.log
    truncate -s 0 $LOG_DIR/collector.log

    NODE_ENV=production node index.js & > $LOG_DIR/server.log
    cd collector
    NODE_ENV=production node index.js & > $LOG_DIR/collector.log
}

