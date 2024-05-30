FROM postgres:latest

# Install OpenSSL and sudo
RUN apt-get update && apt-get install -y openssl sudo curl

# Allow the postgres user to execute certain commands as root without a password
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown" > /etc/sudoers.d/postgres

# Add init scripts
COPY init-ssl.sh /docker-entrypoint-initdb.d/
COPY wrapper.sh /usr/local/bin/wrapper.sh
COPY generate_gobackup_config.sh /usr/local/bin/generate_gobackup_config.sh

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh
RUN chmod +x /usr/local/bin/wrapper.sh
RUN chmod +x /usr/local/bin/generate_gobackup_config.sh

# Install GoBackup
RUN curl -sSL https://github.com/gobackup/gobackup/releases/download/v2.11.2/gobackup-linux-amd64.tar.gz | tar -xz -C /usr/local/bin

# Create directory for GoBackup config
RUN mkdir -p /etc/gobackup

# Expose ports
EXPOSE 5432
EXPOSE 2703

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]