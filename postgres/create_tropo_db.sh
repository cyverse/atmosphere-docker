#!/bin/bash
set -e

POSTGRES="psql --username ${POSTGRES_USER}"

echo "Creating database: ${TROPO_DB_NAME}"

$POSTGRES ${POSTGRES_DB} <<EOSQL
CREATE DATABASE ${TROPO_DB_NAME} OWNER ${POSTGRES_USER};
EOSQL

if [ -e /docker-entrypoint-initdb.d/tropo*.sql.dump ]; then
  echo "Loading Troposphere database dump"
  $POSTGRES ${TROPO_DB_NAME} -f /docker-entrypoint-initdb.d/tropo*.sql.dump
fi
