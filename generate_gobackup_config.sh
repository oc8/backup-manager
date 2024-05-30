#!/bin/bash
set -e

cat <<EOF > /etc/gobackup/gobackup.yml
web:
  host: 0.0.0.0
models:
  ${SERVICE_NAME}:
    compress_with:
      type: tgz
    storages:
      minio:
        type: minio
        bucket: ${MINIO_BUCKET}
        endpoint: ${MINIO_ENDPOINT}
        region: ${MINIO_REGION}
        path: ${MINIO_PATH}
        access_key_id: ${MINIO_ACCESS_KEY_ID}
        secret_access_key: ${MINIO_SECRET_ACCESS_KEY}
    databases:
      ${PGDATABASE}:
        database: ${PGDATABASE}
        type: postgresql
        host: localhost
        port: 5432
        username: ${PGUSER}
        password: ${PGPASSWORD}
EOF
