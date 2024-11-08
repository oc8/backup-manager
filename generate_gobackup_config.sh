#!/bin/bash
set -e

# Start GoBackup configuration
cat <<EOF > /etc/gobackup/gobackup.yml
web:
  host: 0.0.0.0
  password: ${WEB_PASS}
models:
  ${SERVICE_NAME}:
    schedule:
      cron: ${BACKUP_SCHEDULE}
    compress_with:
      type: ${BACKUP_COMPRESS}
    encrypt_with:
      type: openssl
      password: ${ENCRYPT_PASS}
      salt: true
      base64: false
    storages:
      minio:
        type: minio
        bucket: ${MINIO_BUCKET}
        endpoint: ${MINIO_ENDPOINT}
        region: ${MINIO_REGION}
        path: ${MINIO_PATH}
        access_key_id: ${MINIO_ACCESS_KEY_ID}
        secret_access_key: ${MINIO_SECRET_ACCESS_KEY}
EOF

IFS=',' read -ra DBS <<< "${POSTGRES_DBS}"
for DB_NAME in "${DBS[@]}"; do
  cat <<EOF >> /etc/gobackup/gobackup.yml
    databases:
      ${DB_NAME}:
        database: ${DB_NAME}
        type: postgresql
        host: localhost
        port: 5432
        username: ${POSTGRES_USER}
        password: ${POSTGRES_PASSWORD}
EOF
done
