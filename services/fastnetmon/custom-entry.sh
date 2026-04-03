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

if grep -q "Configuration is correct" <<< "$OUTPUT"; then
    echo "Config already present, continuing"
elif grep -q "Can't load configuration from configuration source" <<< "$OUTPUT"; then
    echo "Cannot load config - looks like first start - create config"
    /usr/bin/fcli create_configuration
#else
#    echo "$OUTPUT"
#    exit 1
fi

exec /opt/fastnetmon/app/bin/fastnetmon $FNM_ARGS