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
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli create_configuration
#else
#    echo "$OUTPUT"
#    exit 1
fi

# Enable clickhouse config
if [[ -f $CLICKHOUSE_PASSWORD_FILE ]]; then
    export CLICKHOUSE_PASSWORD="$(< ${CLICKHOUSE_PASSWORD_FILE})"
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main clickhouse_metrics_host ${CLICKHOUSE_HOST}
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main clickhouse_metrics_username ${CLICKHOUSE_USER}
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main clickhouse_metrics_password ${CLICKHOUSE_PASSWORD}
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main clickhouse_metrics true
else
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main clickhouse_metrics false
fi

# Enable traffic_db config
if [[ "${TRAFFICDB_ENABLED:-false}" == "true" ]]; then
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main traffic_db_host ${TRAFFICDB_HOST}
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main traffic_db_port 8100
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main traffic_db enable
else
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main traffic_db false
fi

if [[ "${WEB_API_V2:-false}" == "true" ]]; then
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main web_api_v2 true
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main mongo_store_attack_information true
else
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main web_api_v2 false
fi

WEB_API_PASSWORD_FILE=${WEB_API_PASSWORD_FILE:-/run/secrets/web_api_admin_password}
if [[ -f $WEB_API_PASSWORD_FILE ]]; then
    export WEB_API_PASSWORD="$(< ${WEB_API_PASSWORD_FILE})"
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main web_api_host 0.0.0.0
    HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main web_api_port 10007
    if  [[ "${WEB_API_V2:-false}" == "true" ]]; then
        echo "Enable web api user"
        HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set user ${WEB_API_USER:-admin}
        HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set user ${WEB_API_USER:-admin} password $WEB_API_PASSWORD
    else
        echo "Enable web api login"
        #echo "Enable web api login  ${WEB_API_USER:-admin}  ${WEB_API_PASSWORD}"
        HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main web_api_login ${WEB_API_USER:-admin}
        HTTP_API_MODE=off OFFLINE_MODE=on /usr/bin/fcli set main web_api_password ${WEB_API_PASSWORD}
    fi
fi

FNM_NOT_UPLOAD_ASN_MAPPING="${FNM_NOT_UPLOAD_ASN_MAPPING:-false}"
if [[ "${FNM_NOT_UPLOAD_ASN_MAPPING}" != "true" ]]; then
    echo "Download ASN mapping"
    mkdir -p /var/lib/clickhouse/user_files
    /opt/fastnetmon/app/bin/fill_dictionaries
fi

exec /opt/fastnetmon/app/bin/fastnetmon $FNM_ARGS