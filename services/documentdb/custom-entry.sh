#!/bin/sh
set -e

PASSWORD_FILE="${PASSWORD_FILE:-/run/secrets/mongo_password}"
export PASSWORD="$(cat $PASSWORD_FILE)"

exec /home/documentdb/gateway/scripts/emulator_entrypoint.sh "$@"
