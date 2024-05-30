#!/bin/bash

# Unset PGHOST to force psql to use Unix socket path
# this is specific to Railway and allows us to use PGHOST after the init
unset PGHOST

# Unset PGPORT also specific to Railway
# since postgres checks for validity of the value in PGPORT we unset it in case it ends up being empty
unset PGPORT

# Set environment variables
export SERVICE_NAME="${SERVICE_NAME}"
export MINIO_BUCKET="${MINIO_BUCKET}"
export MINIO_ENDPOINT="${MINIO_ENDPOINT}"
export MINIO_REGION="${MINIO_REGION}"
export MINIO_PATH="${MINIO_PATH}"
export MINIO_ACCESS_KEY_ID="${MINIO_ACCESS_KEY_ID}"
export MINIO_SECRET_ACCESS_KEY="${MINIO_SECRET_ACCESS_KEY}"
export POSTGRES_DB="${POSTGRES_DB}"
export POSTGRES_USER="${POSTGRES_USER}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"

# Call the entrypoint script with the appropriate PGHOST & PGPORT
/usr/local/bin/docker-entrypoint.sh "$@"
