#!/bin/sh
set -eu

PROJECT_DIR="$(pwd)"

if [ ! -f "./docker-compose.yml" ]; then
 echo "Please run this script from the repository root." >&2
    exit 1
fi

SECRETS_NAMES="
mongo_password
clickhouse_password
grafana_admin_password
clickhouse_grafana_password
web_api_admin_password"

for secret in $SECRETS_NAMES;do
    echo "Generate and write $secret"
    if [ -f "${PROJECT_DIR}/secrets/$secret" ]; then
        echo "$secret secret file already exist\n"
    else
        LENGTH=${1:-16}
        password=$(tr -dc 'A-Za-z0-9_@#%*+=-' < /dev/urandom | head -c "$LENGTH")
        if [ "$secret" = "web_api_admin_password" ]; then
            LENGTH=${1:-15}
            password=$(tr -dc 'A-Za-z0-9_@#%*+=-' < /dev/urandom | head -c "$LENGTH")
            password="_$password"
        fi
        printf '%s' "$password" > "${PROJECT_DIR}/secrets/$secret"
    fi
done

echo "Done"