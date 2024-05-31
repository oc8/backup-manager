FROM postgres:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssl \
    sudo \
    curl \
    wget \
    lz4 \
    cron \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GoBackups
RUN curl -sSL https://gobackup.github.io/install | sh

# Allow the postgres user to execute certain commands as root without a password
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown" > /etc/sudoers.d/postgres && \
    chmod 0440 /etc/sudoers.d/postgres

# Add init scripts
COPY init-ssl.sh /docker-entrypoint-initdb.d/
COPY wrapper.sh /usr/local/bin/wrapper.sh
COPY generate_gobackup_config.sh /usr/local/bin/generate_gobackup_config.sh

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh /usr/local/bin/wrapper.sh /usr/local/bin/generate_gobackup_config.sh

# Create directory for GoBackup config
RUN mkdir -p /etc/gobackup

# Expose ports
EXPOSE 5432
EXPOSE 2703

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
