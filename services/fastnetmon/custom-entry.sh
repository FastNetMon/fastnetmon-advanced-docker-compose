#!/bin/bash


# Generate MongoDB config
MONGO_HOST="${MONGO_HOST:-mongo}"
MONGO_USERNAME="${MONGO_USERNAME:-administrator}"
cat > /etc/fastnetmon/fastnetmon.conf <<EOF
{
"mongodb_host": "${MONGO_HOST}",
"mongodb_port": 27017,
"mongodb_database_name": "fastnetmon",
"mongodb_username": "${MONGO_USERNAME}",
"mongodb_auth_source": "admin"
}
EOF

OUTPUT="$(/opt/fastnetmon/app/bin/fastnetmon --configuration_check --log_to_console)"

# Init default config
if grep -q "Configuration is correct" <<< "$OUTPUT"; then
    echo "Config already present, continuing"
elif grep -q "Can't load configuration from configuration source" <<< "$OUTPUT"; then
    echo "Cannot load config - looks like first start - create config"
    /usr/bin/fcli create_configuration
#else
#    echo "$OUTPUT"
#    exit 1
fi

# Enable clickhouse config
if [[ -f $CLICKHOUSE_PASSWORD_FILE ]]; then
    export CLICKHOUSE_PASSWORD="$(< ${CLICKHOUSE_PASSWORD_FILE})"
    /usr/bin/fcli set main clickhouse_metrics_host ${CLICKHOUSE_HOST}
    /usr/bin/fcli set main clickhouse_metrics_username ${CLICKHOUSE_USER}
    /usr/bin/fcli set main clickhouse_metrics_password ${CLICKHOUSE_PASSWORD}
    /usr/bin/fcli set main clickhouse_metrics true
else
    /usr/bin/fcli set main clickhouse_metrics false
fi

# Enable traffic_db config
if [[ "${TRAFFICDB_ENABLED:-false}" == "true" ]]; then
    /usr/bin/fcli set main traffic_db_host ${TRAFFICDB_HOST}
    /usr/bin/fcli set main traffic_db_port 8100
    /usr/bin/fcli set main traffic_db enable
else
    /usr/bin/fcli set main traffic_db false
fi

exec /opt/fastnetmon/app/bin/fastnetmon $FNM_ARGS