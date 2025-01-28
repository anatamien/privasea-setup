#!/bin/bash

# Обновление системы и установка необходимых зависимостей
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление официального GPG-ключа Docker
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Добавление репозитория Docker
echo "Adding Docker repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Обновление индекса пакетов и установка Docker
echo "Installing Docker..."
sudo apt update && sudo apt install -y docker-ce

# Проверка установки Docker
echo "Verifying Docker installation..."
sudo docker --version || { echo "Docker installation failed"; exit 1; }

# Запуск и включение Docker
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Загрузка образа Docker
echo "Pulling Docker image for Privasea node..."
docker pull privasea/acceleration-node-beta || { echo "Failed to pull Docker image"; exit 1; }

# Создание каталога программы и переход в него
echo "Creating configuration directory..."
sudo mkdir -p /privasea/config && cd /privasea

# Генерация keystore
echo "Generating keystore..."
sudo docker run -it -v "/privasea/config:/app/config" privasea/acceleration-node-beta:latest ./node-calc new_keystore

echo "Keystore generation initiated. Please follow the prompts to enter and confirm your password."
