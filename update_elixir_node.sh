#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

echo "===================================================="
wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

# 2. Перехід до директорії elixir
echo "Перехід до директорії elixir..."
cd elixir || { echo "Директорія elixir не знайдена"; exit 1; }

# 3. Зупинка контейнерів elixir
echo "Зупинка контейнерів elixir..."
docker ps -a | grep elixir | awk '{print $1}' | xargs docker stop || echo "Контейнерів не знайдено"

# 4. Видалення контейнерів elixir
echo "Видалення контейнерів elixir..."
docker ps -a | grep elixir | awk '{print $1}' | xargs docker rm || echo "Контейнерів не знайдено"

# 5. Завантаження нового Docker-образу
echo "Завантаження нового Docker-образу..."
docker pull elixirprotocol/validator:v3 --platform linux/amd64

# 6. Запуск нового контейнера
echo "Запуск нового контейнера..."
docker run --name elixir --env-file validator.env --platform linux/amd64 -p 17690:17690 --restart unless-stopped elixirprotocol/validator:v3

echo "===================================================="
echo "Ноду оновлено!"
