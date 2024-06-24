# Pg-GoBackup

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/pI1avl?referralCode=Nv5vOn)

docs: https://gobackup.github.io/getting-started

## Ports

postgres-ssl -> 5432

gobackup web -> 2703

## Cert expiry
By default, the cert expiry is set to 820 days. You can control this by configuring the SSL_CERT_DAYS environment variable as needed.

## Envs

```
SERVICE_NAME=
WEB_PASS= # Password to access gobackup web dashboard
BACKUP_SCHEDULE="0 0 * * *"
BACKUP_COMPRESS=tgz # https://gobackup.github.io/configuration/compressor/tar
ENCRYPT_PASS= # https://gobackup.github.io/configuration/encryptor/openssl
MINIO_BUCKET= # Name of the s3 bucket
MINIO_ENDPOINT= # s3 endpoint
MINIO_REGION= # s3 region
MINIO_PATH= # s3 folder name to store backups
MINIO_ACCESS_KEY_ID= # s3 access id
MINIO_SECRET_ACCESS_KEY= # s3 secret key 
POSTGRES_DB= # Name of the created postgres db
POSTGRES_USER=
POSTGRES_PASSWORD=
```
