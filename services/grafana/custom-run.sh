#!/bin/sh
set -eu

export CLICKHOUSE_GRAFANA_PASSWORD="$(cat /run/secrets/clickhouse_grafana_password)"

exec /run.sh
