#!/bin/bash
set -euo pipefail
sudo -v

ENV_FILE="$(dirname $0)/.env"

if [ -f "${ENV_FILE}" ]; then
  set -a
  source "${ENV_FILE}"
  set +a
fi

(
    cd "$(dirname $0)/../global_net" || {
        echo "Failed to change directory" &&
        exit 1
    } && \
    docker-compose exec -T db mariadb -u root -p${MYSQL_ROOT_PASSWORD} \
        -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
)