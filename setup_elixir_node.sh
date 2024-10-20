#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

echo "===================================================="
wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

echo "===================================================="
echo "Оновлення залежностей..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git jq lz4 build-essential unzip

echo "===================================================="
echo "Встановлення Docker..."
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

echo "===================================================="
echo "Створення директорії для валідатора..."
mkdir -p ~/elixir && cd ~/elixir

echo "Завантаження файлу валідатора..."
wget https://files.elixir.finance/validator.env

echo "===================================================="
echo "Відкриття редактора для налаштування validator.env..."
# Відкриваємо nano для редагування validator.env
nano validator.env

# Продовжуємо після закриття редактора
echo "===================================================="
echo "Завантаження Docker-образу..."
docker pull elixirprotocol/validator:v3

echo "===================================================="
echo "Запуск валідатора..."
docker run -d --env-file ~/elixir/validator.env --name elixir --platform linux/amd64 elixirprotocol/validator:v3

echo "===================================================="
echo "Валідатор запущений. Перегляньте id контейнера docker container ls"
