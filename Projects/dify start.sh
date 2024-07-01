# Function to check and wait for a port to be available
check_port() {
    local port=$1
    while lsof -i :"$port" > /dev/null; do
        echo "Port $port is in use, killing the process..."
        kill -9 $(lsof -t -i :"$port")
        echo "Process killed, waiting 5 seconds..."
        sleep 20
    done
}
# Stop all running containers
docker stop $(docker ps -a -q)

# Remove all containers
docker rm $(docker ps -a -q)

# Remove orphaned volumes
docker volume prune -f

sleep 20
# Check and wait for ports 8080, 5432, 8194, 6379, 3001, 3002, and 3003 to be available
check_port 8080
check_port 5432
check_port 8194
check_port 6379
check_port 3001
check_port 3002
check_port 3003

# Stop and remove the existing Docker containers
cd /root/dify/docker
docker compose -f docker-compose.middleware.yaml -p dify down

# Start the new Docker containers
docker compose -f docker-compose.middleware.yaml -p dify up -d

# Start the API application
cd /root/dify/api
poetry run python -m flask run --host 0.0.0.0 --port=5001 --debug &

# Start the web application
cd /root/dify/web
poetry run python -m flask run --host 0.0.0.0 --port=5001 --debug &
npm run dev &

# Start the API application
cd /root/dify/api
poetry run python -m celery -A app.celery worker -P gevent -c 1 --loglevel INFO -Q dataset,generation,mail,ops_trace



