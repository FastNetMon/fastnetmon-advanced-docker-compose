#!/bin/bash

SECRETS_NAMES=( "mongo_password" "clickhouse_password" "grafana_admin_password" "clickhouse_grafana_password")

for secret in "${SECRETS_NAMES[@]}"
do
    echo "Generate and write $secret"
    password=`printf "%s" $(pwgen 16 1)`
    echo -n $password > secrets/$secret
done

echo "Done"