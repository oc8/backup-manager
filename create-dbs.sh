#!/bin/bash
set -e

IFS=',' read -ra DBS <<< "${POSTGRES_DBS}"
for DB_NAME in "${DBS[@]}"; do
  echo "Checking if database exists: $DB_NAME"

  DB_EXISTS=$(psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

  if [ "$DB_EXISTS" != "1" ]; then
    echo "Creating database: $DB_NAME"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
      CREATE DATABASE "$DB_NAME";
EOSQL
  else
    echo "Database $DB_NAME already exists, skipping creation."
  fi
done
