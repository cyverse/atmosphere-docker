#!/bin/bash
set -e

POSTGRES="psql --username ${POSTGRES_USER} ${POSTGRES_DB}"

echo "Creating database: ${TROPO_DB_NAME}"

$POSTGRES <<EOSQL
CREATE DATABASE ${TROPO_DB_NAME} OWNER ${POSTGRES_USER};
EOSQL
