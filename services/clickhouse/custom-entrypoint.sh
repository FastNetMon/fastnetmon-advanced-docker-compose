#!/bin/bash
set -e

CLICKHOUSE_PASSWORD_FILE="${CLICKHOUSE_PASSWORD_FILE:-/run/secrets/clickhouse_password}"
export CLICKHOUSE_PASSWORD="$(cat $CLICKHOUSE_PASSWORD_FILE)"

GRAFANA_PASSWORD_FILE="${GRAFANA_PASSWORD_FILE:-/run/secrets/clickhouse_grafana_password}"

if [[ -f "$GRAFANA_PASSWORD_FILE" ]]; then
  #GRAFANA_PASSWORD="$(<"$GRAFANA_PASSWORD_FILE")"
  PASSWORD_SHA256_HEX="$(tr -d '\r\n' < $GRAFANA_PASSWORD_FILE | sha256sum | awk '{print $1}')"

  GRAFANA_USER="${CLICKHOUSE_GRAFANA_USER:-grafana}"
  cat > /etc/clickhouse-server/users.d/grafana.xml <<EOF
<yandex><users><${GRAFANA_USER}><password_sha256_hex>${PASSWORD_SHA256_HEX}</password_sha256_hex><profile>default</profile><quota>default</quota></${GRAFANA_USER}></users></yandex>
EOF
fi


exec /entrypoint.sh
