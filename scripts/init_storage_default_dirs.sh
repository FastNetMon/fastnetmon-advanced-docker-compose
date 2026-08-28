#!/bin/sh
set -eu

PROJECT_DIR="$(pwd)"

if [ ! -f "./docker-compose.yml" ]; then
 echo "Please run this script from the repository root." >&2
    exit 1
fi

mkdir -p ${PROJECT_DIR}/storage/mongo/data/
touch ${PROJECT_DIR}/storage/mongo/data/.gitkeep
touch ${PROJECT_DIR}/storage/.gitkeep

mkdir -p ${PROJECT_DIR}/storage/fastnetmon/logs/
touch ${PROJECT_DIR}/storage/fastnetmon/logs/.gitkeep
touch ${PROJECT_DIR}/storage/fastnetmon/.gitkeep

mkdir -p ${PROJECT_DIR}/storage/fastnetmon_web_api/logs/
touch ${PROJECT_DIR}/storage/fastnetmon_web_api/logs/.gitkeep

mkdir -p ${PROJECT_DIR}/storage/clickhouse/data/
touch ${PROJECT_DIR}/storage/clickhouse/data/.gitkeep

mkdir -p ${PROJECT_DIR}/storage/clickhouse/logs/
touch ${PROJECT_DIR}/storage/clickhouse/logs/.gitkeep

mkdir -p ${PROJECT_DIR}/storage/grafana/data/
touch ${PROJECT_DIR}/storage/grafana/data/.gitkeep



