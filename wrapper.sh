#!/bin/bash
set -e

# unset PGHOST to force psql to use Unix socket path
# this is specific to Railway and allows
# us to use PGHOST after the init
unset PGHOST

# unset PGPORT also specific to Railway
# since postgres checks for validity of
# the value in PGPORT we unset it in case
# it ends up being empty
unset PGPORT

# Generate GoBackup configuration
/usr/local/bin/generate_gobackup_config.sh

# Start PostgreSQL in the background
sudo -u postgres /usr/local/bin/docker-entrypoint.sh postgres --port=5432 &

# Wait for PostgreSQL to start
until pg_isready -h localhost -p 5432; do
  sleep 1
done

# Start GoBackup
gobackup web &

# Wait for all background processes
wait -n
