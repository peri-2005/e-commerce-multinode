#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>&1) 2>&1

echo "Updating baseline package tables..."
apt-get update -y

echo "Installing Docker Engine and Git..."
apt-get install -y docker.io git
systemctl start docker
systemctl enable docker

echo "Downloading Docker Compose V2 binary plugin..."
DOCKER_CONFIG=${DOCKER_CONFIG:-/usr/local/lib/docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

echo "Cloning the application codebase from remote Git repository..."
APP_DIR="/opt/ecommerce-app"
# Adjust the source URL below to your actual project repository
git clone https://github.com/peri-2005/e-commerce-multinode.git $APP_DIR

echo "Orchestrating production microservices stack..."
cd $APP_DIR
docker compose up -d --build

echo "Deployment pipeline executed successfully!"
