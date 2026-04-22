#!/bin/bash

SECRETS_NAMES=( "mongo_password" "clickhouse_password" "grafana_admin_password" "clickhouse_grafana_password" "web_api_admin_password")

for secret in "${SECRETS_NAMES[@]}"
do
    echo "Generate and write $secret"
    if [[ -f "secrets/$secret" ]]; then
        echo -e "$secret secret file already exist\n"
    else
        password=`printf "%s" $(pwgen 16 1)`
        if [[ "$secret" == "web_api_admin_password" ]]; then
            password=`printf "_%s" $(pwgen 15 1)`
        fi
        echo -n $password > secrets/$secret
    fi
done

echo "Done"