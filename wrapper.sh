#!/bin/bash

# Unset PGHOST to force psql to use Unix socket path
# this is specific to Railway and allows us to use PGHOST after the init
unset PGHOST

# Unset PGPORT also specific to Railway
# since postgres checks for validity of the value in PGPORT we unset it in case it ends up being empty
unset PGPORT

# Generate GoBackup configuration
/usr/local/bin/generate_gobackup_config.sh

# Start GoBackup server
/usr/local/bin/gobackup start

# Call the entrypoint script with the appropriate PGHOST & PGPORT
/usr/local/bin/docker-entrypoint.sh "$@"
