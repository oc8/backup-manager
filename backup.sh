#!/bin/bash

echo "cron test"

# Create the backup using wal-g
/usr/local/bin/wal-g backup-push

# Remove old backups to save space
/usr/local/bin/wal-g delete retain 7 --confirm
