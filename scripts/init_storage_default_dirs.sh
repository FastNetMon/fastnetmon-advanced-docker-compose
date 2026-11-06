#!/bin/sh
set -eu

PROJECT_DIR="$(pwd)"

if [ ! -f "./docker-compose.yml" ]; then
 echo "Please run this script from the repository root." >&2
    exit 1
fi

DIRECTORYS="
mongo/data/
fastnetmon/logs/
fastnetmon/logs/attacks_dumps
fastnetmon/lib/
fastnetmon/cache/
fastnetmon_web_api/logs/
clickhouse/data/
clickhouse/logs/
grafana/data
documentdb/data
"

GIT_KEEPS="
.gitkeep
mongo/data/.gitkeep
fastnetmon/logs/.gitkeep
fastnetmon/.gitkeep
fastnetmon_web_api/logs/.gitkeep
clickhouse/data/.gitkeep
clickhouse/logs/.gitkeep
grafana/data/.gitkeep
"

echo "Create storage dirs"
for dir in $DIRECTORYS; do
    echo "Create $dir"
    mkdir -p "${PROJECT_DIR}/storage/${dir}"
done

echo "Recreate storage .gitkeep files"
for file in $GIT_KEEPS; do
    touch "${PROJECT_DIR}/storage/${file}"
done

echo "Done"
exit 0
