#!/bin/sh

set -eu

COMPOSE_FILE="docker-compose.yml"
SERVICE_NAME="fastnetmon"

# Please change to directory, if want to move script to $PATH
PROJECT_DIR="$(pwd)"

if [ ! -f "./docker-compose.yml" ]; then
 echo "Please run this script from the repository root." >&2
    exit 1
fi


PARAM1="${1:-}"
PARAM2="${2:-}"


if [ "$PARAM1" = "commit" ]; then
    docker compose -f $COMPOSE_FILE restart $SERVICE_NAME
    exit $?
fi

if [ "$PARAM1" = "show" ];then
    if [ "$PARAM2" = "log" ];then
        docker compose -f $COMPOSE_FILE logs $SERVICE_NAME
        exit $?
    fi
fi

docker compose -f $COMPOSE_FILE exec $SERVICE_NAME fcli $@
