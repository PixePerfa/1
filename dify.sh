#!/bin/bash

# Install required dependencies
sudo apt update
sudo apt install -y python3 python3-pip virtualenv npm

# Clone Dify repository
git clone https://github.com/langgenius/dify.git
cd dify

# Set up virtual environment
virtualenv venv
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Install Node.js dependencies
npm install

# Set up Dify environment variables (adjust as needed)
export DJANGO_SECRET_KEY="your_secret_key"
export DEBUG=True
export DATABASE_URL="sqlite:///db.sqlite3"
export DJANGO_ALLOWED_HOSTS="localhost 127.0.0.1 [::1]"
export DJANGO_CORS_ORIGIN_WHITELIST="http://localhost:3000"
export DJANGO_SUPERUSER_USERNAME="admin"
export DJANGO_SUPERUSER_EMAIL="admin@example.com"
export DJANGO_SUPERUSER_PASSWORD="admin_password"

# Apply migrations
python manage.py migrate

# Create superuser
echo "from django.contrib.auth.models import User; User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD')" | python manage.py shell

# Start Dify server
python manage.py runserver
