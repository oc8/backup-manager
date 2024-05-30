FROM postgres:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssl \
    sudo \
    curl \
    wget \
    lz4 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install wal-g
RUN wget -qO- https://github.com/wal-g/wal-g/releases/download/v3.0.0/wal-g-pg-ubuntu-20.04-amd64.tar.gz | tar xvz -C /usr/local/bin/ && mv /usr/local/bin/wal-g-pg-ubuntu-20.04-amd64 /usr/local/bin/wal-g

# Allow the postgres user to execute certain commands as root without a password
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown" > /etc/sudoers.d/postgres && \
    chmod 0440 /etc/sudoers.d/postgres

# Add init scripts
COPY init-ssl.sh /docker-entrypoint-initdb.d/
COPY wrapper.sh /usr/local/bin/wrapper.sh

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh /usr/local/bin/wrapper.sh

# Expose ports
EXPOSE 5432

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
