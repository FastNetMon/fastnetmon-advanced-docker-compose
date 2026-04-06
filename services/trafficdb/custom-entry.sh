#!/bin/bash

CLICKHOUSE_HOST="${CLICKHOUSE_HOST:-clickhouse}"
CLICKHOUSE_USER="${CLICKHOUSE_USER:-fastnetmon}"
CLICKHOUSE_PASSWORD_FILE="${CLICKHOUSE_PASSWORD_FILE:-/run/secrets/clickhouse_password}"


export CLICKHOUSE_PASSWORD="$(< ${CLICKHOUSE_PASSWORD_FILE})"

mkdir -p "/etc/fastnetmon/"

cat > /etc/fastnetmon/traffic_db.conf <<EOF
{
"traffic_db_host":"::",
"traffic_db_port": 8100,
"clickhouse_batch_size": 1000,
"clickhouse_batch_delay": 1,
"clickhouse_host": "${CLICKHOUSE_HOST}",
"clickhouse_port": 9000,
"clickhouse_user": "${CLICKHOUSE_USER}",
"clickhouse_password": "${CLICKHOUSE_PASSWORD}",
"clickhouse_database_name": "fastnetmon",
"clickhouse_table_name": "traffic"
}
EOF

exec /opt/fastnetmon/app/bin/traffic_db --log_to_console