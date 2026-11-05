#!/bin/sh
set -e

export PASSWORD="$(cat /run/secrets/mongo_password)"

exec /home/documentdb/gateway/scripts/emulator_entrypoint.sh "$@"
