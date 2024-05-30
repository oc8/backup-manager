#!/bin/bash

SSL_DIR="/var/lib/postgresql/data/certs"

# Use sudo to create the directory as root
sudo mkdir -p "$SSL_DIR"

# Use sudo to change ownership as root
sudo chown postgres:postgres "$SSL_DIR"

# Check if certificates already exist
if [ ! -f "$SSL_DIR/server.key" ] || [ ! -f "$SSL_DIR/server.crt" ] || [ ! -f "$SSL_DIR/root.crt" ]; then
    # Generate Root CA
    openssl req -new -x509 -days "${SSL_CERT_DAYS:-820}" -nodes -text -out "$SSL_DIR/root.crt" -keyout "$SSL_DIR/root.key" -subj "/CN=root-ca"

    # Generate Server Certificates
    openssl req -new -nodes -text -out "$SSL_DIR/server.csr" -keyout "$SSL_DIR/server.key" -subj "/CN=localhost"
    openssl x509 -req -in "$SSL_DIR/server.csr" -text -out "$SSL_DIR/server.crt" -CA "$SSL_DIR/root.crt" -CAkey "$SSL_DIR/root.key" -CAcreateserial

    chown postgres:postgres "$SSL_DIR/server.key"
    chmod 600 "$SSL_DIR/server.key"
fi

# PostgreSQL configuration
cat >> "$PGDATA/postgresql.conf" <<EOF
ssl = on
ssl_cert_file = '$SSL_DIR/server.crt'
ssl_key_file = '$SSL_DIR/server.key'
ssl_ca_file = '$SSL_DIR/root.crt'
EOF

# WAL-G configuration
cat >> "$PGDATA/postgresql.conf" <<EOF
archive_mode = on
archive_command = '/usr/local/bin/wal-g wal-push %p'
archive_timeout = 60
EOF

# Create the necessary directories for WAL-G
mkdir -p /var/lib/postgresql/wal
