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
        password=""
        LENGTH=16
        while [ "${#password}" -lt "$LENGTH" ]; do
            chunk=$(head -c 64 /dev/urandom | tr -dc 'A-Za-z0-9_-')
            password="${password}${chunk}"
        done
        password=$(printf '%s' "$password" | cut -c "1-$LENGTH")

        if [ "$secret" = "web_api_admin_password" ]; then
            password=$(printf '%s' "$password" | sed 's/^./_/')
        fi
        printf '%s' "$password" > "${PROJECT_DIR}/secrets/$secret"
    fi
done

echo "Done"
